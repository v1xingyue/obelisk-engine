package main

import (
	"context"
	"flag"
	"os"
	"os/signal"
	"syscall"

	"github.com/0xobelisk/obelisk-engine/package/indexer/client"
	"github.com/0xobelisk/obelisk-engine/package/indexer/config"
	"github.com/0xobelisk/obelisk-engine/package/indexer/db"
	"github.com/0xobelisk/obelisk-engine/package/indexer/logger"
	"github.com/0xobelisk/obelisk-engine/package/indexer/parser"
	"github.com/0xobelisk/obelisk-engine/package/indexer/query"
	"github.com/0xobelisk/obelisk-engine/package/indexer/sync"
	"github.com/0xobelisk/obelisk-engine/package/indexer/types"

	"go.uber.org/zap"
)

var (
	HttpRpcUrl   = flag.String("http-rpc-url", "", "sui http rpc")
	Package      = flag.String("package", "", "sui package")
	Modules      = flag.String("modules", "world", "sui module")
	SyncCursorTx = flag.String("sync-cursor-tx", "", "sync begin cursor tx")
	DbPath       = flag.String("db-path", "./suidb", "db path")
)

func main() {
	flag.Parse()
	logger.InitLogger()

	cfg, err := config.InitFromFlags(*HttpRpcUrl, *SyncCursorTx, *Package, *Modules, *DbPath)
	if err != nil {
		logger.GetLogger().Error("init from flags  err: ", zap.Error(err))
		return
	}
	logger.GetLogger().Debug(" config content: ", zap.Any("cfg", cfg))

	cli, err := client.NewClient(cfg.HttpRpcUrl)
	if err != nil {
		logger.GetLogger().Error("new client err: ", zap.Error(err))
		return
	}

	// sync init
	eventChan := make(chan *types.SuiEvent, 1000)
	s := sync.NewSync(cfg, cli, eventChan)
	errChn := make(chan error)
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	go s.Start(ctx, errChn)

	// db init
	db, err := db.NewDB(cfg.DbPath)
	if err != nil {
		logger.GetLogger().Error("db init err: ", zap.Error(err))
		return
	}

	// parser init
	p := parser.NewParser(cfg, eventChan, db)
	go p.Start()

	// query init
	q := query.NewQueryServer(db)
	go q.Start()

	// signal
	sysErr := make(chan os.Signal, 1)
	signal.Notify(sysErr,
		syscall.SIGTERM,
		syscall.SIGINT,
		syscall.SIGHUP,
		syscall.SIGQUIT)

	select {
	case err := <-errChn:
		logger.GetLogger().Error("failed to listen and serve  ", zap.Error(err))
	case sig := <-sysErr:
		logger.GetLogger().Error("terminating got signal", zap.Any("signal", sig))
	}
}
