package main

import hashmap "lib/" 
import "core:fmt"

main :: proc() {
    hmap := hashmap.map_init(string)
    ihmap := hashmap.map_init(int)
    err := hashmap.map_insert(&hmap, "test2", "ligma")
    if err != hashmap.Errors.OK {
        hashmap.print_err("could not insert")
    }

    err = hashmap.map_insert(&ihmap, "test2", 32)
    if err != hashmap.Errors.OK {
        hashmap.print_err("could not insert")
    }

    val, ok := hashmap.map_get(&hmap, "test2").(string)
    if !ok {
        hashmap.print_err("could not get element")
    }

    ival, iok := hashmap.map_get(&ihmap, "test2").(int)
    if !iok {
        hashmap.print_err("could not get element")
    }

    hashmap.map_print(&hmap)
    fmt.println("------IMAP------")
    hashmap.map_print(&ihmap)

    fmt.println(ival)
}

