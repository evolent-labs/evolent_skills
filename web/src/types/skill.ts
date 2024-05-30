export type Skill = {
  label: string,
  level: number,
  xp: number,
  levelData: {
    minXp: number,
    maxXp: number,
  },
  icon: string,
  color: string,
}