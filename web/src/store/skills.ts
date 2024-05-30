import type { Skill } from "$types/skill";
import { writable } from "svelte/store";

export const skills = writable<Skill[]>()
