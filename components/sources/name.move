module components::name {
    use std::string;
    use sui::tx_context::TxContext;
    use sui::object;
    use eps::entity;
    use eps::world;
    use eps::world::{World};
    use components::utils::generate_component_id;

    const COMPONENT_NAME: vector<u8> = b"Obelisk component name";

    struct Name has store {
        value: string::String
    }

    public entry fun update_name<T : key + store>(world: &mut World, entity_key: &T, name: vector<u8>, _ctx: &mut TxContext) {
        let id = object::id(entity_key);
        let entity = world::get_mut_entity(world, id);
        let components_id = generate_component_id(COMPONENT_NAME);
        let component = entity::get_component<Name>(entity, components_id);
        component.value = string::utf8(name);
    }
}