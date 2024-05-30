<script lang="ts">
  import { skills } from "../store/skills";
  import Skill from "./Skill.svelte";
  import { slide } from "svelte/transition";
</script>

<div
  class="skills-container"
  in:slide={{ duration: 200 }}
  out:slide={{ duration: 200 }}
>
  <div class="skills-header">
    <p><span>Your</span> Skills</p>
  </div>

  <div class="skills-list">
    {#each $skills as skill (skill.label)}
      <Skill {skill} />
    {/each}
  </div>
</div>

<style scoped>
  @import "$styles/skills.css";
</style>
