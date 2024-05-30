<script lang="ts">
  import type { Skill } from "$types/skill";
  import { hexToRgba } from "../utils/hexToRgba";
  import { onMount } from "svelte";

  export let skill: Skill;
  let backgroundColor: string;
  let levelPercentage: number;

  const calculateLevelPercentage = (): number => {
    const currentLevelData = skill.levelData;
    if (!skill.xp) {
      return 0;
    }

    const progress =
      (skill.xp - currentLevelData.minXp) /
      (currentLevelData.maxXp - currentLevelData.minXp);

    return Math.round(Math.max(0, Math.min(progress, 1)) * 100 * 100) / 100;
  };

  $: levelPercentage = calculateLevelPercentage();
  $: backgroundColor = hexToRgba(skill.color, 0.11);

  onMount(() => {
    levelPercentage = calculateLevelPercentage();
  });
</script>

<div class="skill-container">
  <div
    class="skill-icon"
    style="--skill-color: {skill.color}; --skill-bg-color: {backgroundColor};"
  >
    <i class={skill.icon}></i>
  </div>
  <div class="skill-data">
    <div class="skill-data-upper">
      <p class="skill-label" style="color: {skill.color}">{skill.label}</p>
      <div class="skill-level" style="--skill-bg-color: {backgroundColor};">
        <i class="fas fa-chart-line"></i>
        <p>{skill.level}</p>
      </div>
    </div>
    <div class="skill-data-lower">
      <p class="skill-xp">
        XP: {skill.xp}/{skill.levelData.maxXp}
      </p>
    </div>
    <div class="skill__progress-bar">
      <div
        class="skill-progress-bar"
        style="width: {levelPercentage}%; background-color: {skill.color}"
      ></div>
    </div>
  </div>
</div>

<style scoped>
  @import "$styles/skill.css";
</style>
