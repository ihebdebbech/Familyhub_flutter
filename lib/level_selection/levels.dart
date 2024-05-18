const gameLevels = <GameLevel>[
  (
    number: 1,
    winScore: 3,
    canSpawnTall: false,
  ),
  (
    number: 2,
    winScore:10,
    canSpawnTall: true,
  ),
  (
    number: 3,
    winScore: 20,
    canSpawnTall: true,
  ),
];

typedef GameLevel = ({
  int number,
  int winScore,
  bool canSpawnTall,
});
