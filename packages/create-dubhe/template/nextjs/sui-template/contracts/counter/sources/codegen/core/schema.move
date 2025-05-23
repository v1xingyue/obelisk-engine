  // Copyright (c) Obelisk Labs, Inc.
  // SPDX-License-Identifier: Apache-2.0
  #[allow(unused_use)]
  
  /* Autogenerated file. Do not edit manually. */
  
  module counter::counter_schema {

  use std::ascii::String;

  use std::ascii::string;

  use sui::package::UpgradeCap;

  use std::type_name;

  use dubhe::storage;

  use dubhe::storage_value::{Self, StorageValue};

  use dubhe::storage_map::{Self, StorageMap};

  use dubhe::storage_double_map::{Self, StorageDoubleMap};

  use sui::dynamic_field as df;

  use counter::counter_dapp_metadata::DappMetadata;

  public struct Schema has key, store {
    id: UID,
  }

  // Default storage

  public fun borrow_dapp__admin(self: &Schema): &StorageValue<address> {
    storage::borrow_field(&self.id, b"dapp__admin")
  }

  public fun borrow_dapp__package_id(self: &Schema): &StorageValue<address> {
    storage::borrow_field(&self.id, b"dapp__package_id")
  }

  public fun borrow_dapp__version(self: &Schema): &StorageValue<u32> {
    storage::borrow_field(&self.id, b"dapp__version")
  }

  public fun borrow_dapp__metadata(self: &Schema): &StorageValue<DappMetadata> {
    storage::borrow_field(&self.id, b"dapp__metadata")
  }

  public fun borrow_dapp__safe_mode(self: &Schema): &StorageValue<bool> {
    storage::borrow_field(&self.id, b"dapp__safe_mode")
  }

  public fun borrow_dapp__authorised_schemas(self: &Schema): &StorageValue<vector<address>> {
    storage::borrow_field(&self.id, b"dapp__authorised_schemas")
  }

  public fun borrow_dapp__schemas(self: &Schema): &StorageValue<vector<address>> {
    storage::borrow_field(&self.id, b"dapp__schemas")
  }

  public(package) fun dapp__admin(self: &mut Schema): &mut StorageValue<address> {
    storage::borrow_mut_field(&mut self.id, b"dapp__admin")
  }

  public(package) fun dapp__package_id(self: &mut Schema): &mut StorageValue<address> {
    storage::borrow_mut_field(&mut self.id, b"dapp__package_id")
  }

  public(package) fun dapp__version(self: &mut Schema): &mut StorageValue<u32> {
    storage::borrow_mut_field(&mut self.id, b"dapp__version")
  }

  public(package) fun dapp__metadata(self: &mut Schema): &mut StorageValue<DappMetadata> {
    storage::borrow_mut_field(&mut self.id, b"dapp__metadata")
  }

  public(package) fun dapp__safe_mode(self: &mut Schema): &mut StorageValue<bool> {
    storage::borrow_mut_field(&mut self.id, b"dapp__safe_mode")
  }

  public(package) fun dapp__authorised_schemas(self: &mut Schema): &mut StorageValue<vector<address>> {
    storage::borrow_mut_field(&mut self.id, b"dapp__authorised_schemas")
  }

  public fun borrow_value(self: &Schema): &StorageValue<u32> {
    storage::borrow_field(&self.id, b"value")
  }

  public(package) fun value(self: &mut Schema): &mut StorageValue<u32> {
    storage::borrow_mut_field(&mut self.id, b"value")
  }

  public(package) fun create(ctx: &mut TxContext): Schema {
    let mut id = object::new(ctx);
    storage::add_field<StorageValue<u32>>(&mut id, b"value", storage_value::new(b"value", ctx));
    Schema { id }
  }

  public(package) fun id(self: &mut Schema): &mut UID {
    &mut self.id
  }

  public(package) fun borrow_id(self: &Schema): &UID {
    &self.id
  }

  public fun migrate(_schema: &mut Schema, _ctx: &mut TxContext) {}

  public(package) fun upgrade(schema: &mut Schema, new_package_id: address, new_version: u32, ctx: &mut TxContext) {
    assert!(schema.dapp__metadata().contains(), 0);
    assert!(schema.dapp__admin().get() == ctx.sender(), 0);
    schema.dapp__package_id().set(new_package_id);
    let current_version = schema.dapp__version()[];
    assert!(current_version < new_version, 0);
    schema.dapp__version().set(new_version);
    schema.migrate(ctx);
  }

  // ======================================== View Functions ========================================

  public fun get_value(self: &Schema): &u32 {
    self.borrow_value().get()
  }

  // =========================================================================================================
}
