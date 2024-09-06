// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<3x4xi32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<3x4xi32>
    %1 = call @expected() : () -> tensor<3x4xi32>
    stablehlo.custom_call @check.expect_eq(%0, %1) {has_side_effect = true} : (tensor<3x4xi32>, tensor<3x4xi32>) -> ()
    return %0 : tensor<3x4xi32>
  }
  func.func private @inputs() -> (tensor<3x4xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[-1, 3, 1, 3], [2, 0, 3, -3], [0, 0, 1, 0]]> : tensor<3x4xi32>
    return %c : tensor<3x4xi32>
  }
  func.func private @expected() -> (tensor<3x4xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[-1, 3, 1, 3], [2, 0, 3, -3], [0, 0, 1, 0]]> : tensor<3x4xi32>
    return %c : tensor<3x4xi32>
  }
}