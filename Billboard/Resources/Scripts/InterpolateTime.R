

readHumdrum('Data/.*hum') -> bb
bb |> filter(Spine == 3 | Exclusive == 'timestamp') |> removeEmptySpines() -> bb
