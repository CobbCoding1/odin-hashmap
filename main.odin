package main

T :: int

import hashmap "lib/" 
import "core:fmt"

main :: proc() {
    hmap := hashmap.map_init()
    err := hashmap.map_insert(&hmap, "test2", 53)
    if err != hashmap.Errors.OK {
        hashmap.print_err("could not insert")
    }

    val, ok := hashmap.map_get(&hmap, "test2").(T)
    if !ok {
        hashmap.print_err("could not get element")
    }

    hashmap.map_print(&hmap)
}
