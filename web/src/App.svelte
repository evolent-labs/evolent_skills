<script lang="ts">
  import VisibilityProvider from './providers/VisibilityProvider.svelte';
  import Skills from './components/Skills.svelte';
  import { debugData } from './utils/debugData';
  import type { Skill } from '$types/skill.ts';

  debugData<{ visible: boolean, playerSkills: Skill[] }>([
    {
      action: 'showSkills',
      data: {
        visible: true,
        playerSkills: [
          {
            label: 'Driving',
            level: 2,
            xp: 176,
            icon: 'fas fa-car',
            color: '#AFC1FF',
            levelData: {
              minXp: 100,
              maxXp: 200
            }
          },
          {
            label: 'Shooting',
            level: 2,
            xp: 104,
            icon: 'fa-solid fa-gun',
            color: '#ff8888',
            levelData: {
              minXp: 100,
              maxXp: 200
            }
          },
        ]
      }
    }
  ]);
</script>

<main>
  <VisibilityProvider>
    <Skills />
  </VisibilityProvider>
</main>

<style>
  @import '$styles/global.css';
  main {
    height: 100vh;
    display: flex;
    justify-content: flex-end;
    align-items: center;
    padding-right: 2.0800vw;
  }
</style>
