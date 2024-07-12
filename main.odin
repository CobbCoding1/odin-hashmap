package main

import hashmap "lib/" 
import "core:fmt"

T :: string 

main :: proc() {
    hmap := hashmap.map_init(T)
    err := hashmap.map_insert(T, &hmap, "test2", "ligma")
    if err != hashmap.Errors.OK {
        hashmap.print_err("could not insert")
    }

    val, ok := hashmap.map_get(T, &hmap, "test2").(T)
    if !ok {
        hashmap.print_err("could not get element")
    }

    hashmap.map_print(T, &hmap)
}
