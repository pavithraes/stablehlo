// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<5x7xi16> {jax.result_info = "[0]", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<5x7xi16>
    %1 = call @expected() : () -> tensor<5x7xi16>
    %2 = "stablehlo.sort"(%0) <{dimension = 0 : i64}> ({
    ^bb0(%arg0: tensor<i16>, %arg1: tensor<i16>):
      %3 = stablehlo.compare  LT, %arg0, %arg1,  SIGNED : (tensor<i16>, tensor<i16>) -> tensor<i1>
      stablehlo.return %3 : tensor<i1>
    }) : (tensor<5x7xi16>) -> tensor<5x7xi16>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<5x7xi16>, tensor<5x7xi16>) -> ()
    return %2 : tensor<5x7xi16>
  }
  func.func private @inputs() -> (tensor<5x7xi16> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[0, 0, -2, 1, 1, 3, 0], [4, 3, 1, -5, 0, 0, -4], [0, 2, 2, 4, 1, -1, 0], [-1, -5, -3, 1, -3, 0, 0], [-3, 0, 1, -1, -3, -2, -3]]> : tensor<5x7xi16>
    return %c : tensor<5x7xi16>
  }
  func.func private @expected() -> (tensor<5x7xi16> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[-3, -5, -3, -5, -3, -2, -4], [-1, 0, -2, -1, -3, -1, -3], [0, 0, 1, 1, 0, 0, 0], [0, 2, 1, 1, 1, 0, 0], [4, 3, 2, 4, 1, 3, 0]]> : tensor<5x7xi16>
    return %c : tensor<5x7xi16>
  }
}