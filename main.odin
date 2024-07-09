package main

import "core:fmt"

Data :: struct {
    val: int,
    key: int,
    unavailable: bool,
}

Map :: struct {
    data: [dynamic]Data,
}

hash :: proc(n: int) -> int {
    return (n * 10 + 2) / 3
}

map_init :: proc() -> Map {
    hashmap := Map{}
    hashmap.data = make([dynamic]Data, 32)
    return hashmap
}

map_insert :: proc(hashmap: ^Map, key: int, val: int) {
    index := hash(key) % cap(hashmap.data) 

    data := Data{val, key, true}

    for hashmap.data[index].unavailable == true {
        if index >= cap(hashmap.data) { index = 0 }
        index += 1
    }

    inject_at(&hashmap.data, index, data)
}

map_get :: proc(hashmap: ^Map, key: int) -> int {
    index := hash(key) % cap(hashmap.data) 

    for hashmap.data[index].key != key {
        if hashmap.data[index].unavailable {
            return -1
        }
        if index >= cap(hashmap.data) { index = 0 }
        index += 1
    }

    return hashmap.data[index].val
}

map_delete :: proc(hashmap: ^Map, key: int) {
    index := hash(key) % cap(hashmap.data) 

    for hashmap.data[index].key != key {
        if hashmap.data[index].unavailable {
            return
        }
        if index >= cap(hashmap.data) { index = 0 }
        index += 1
    }
    
    inject_at(&hashmap.data, index, Data{})
}

main :: proc() {
    hashmap := map_init()
    map_insert(&hashmap, 1, 5)
    map_insert(&hashmap, 2, 10)
    map_insert(&hashmap, 3, 15)
    map_insert(&hashmap, 4, 20)
    map_insert(&hashmap, 5, 25)

    for val in hashmap.data {
        fmt.println(val)
    }
    fmt.println(map_get(&hashmap, 3))

    fmt.println("Hello, world!")
}



