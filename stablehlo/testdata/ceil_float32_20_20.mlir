// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xf32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xf32>
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = stablehlo.ceil %0 : tensor<20x20xf32>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<20x20xf32>, tensor<20x20xf32>) -> ()
    return %2 : tensor<20x20xf32>
  }
  func.func private @inputs() -> (tensor<20x20xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x64EE8C3E26DA673CDD4734C0D0620C40F0F54C4082C445C001946E3F15F347C08FB55BBF831BFBC016FF1A40C0784E3FA9C94CBFE7925040AD61C1BF51BB123FC5D687BF66ABA73F2EF854BE1BF523C0F83D26BFD1F4C24056BF493F4D9042C035DA3F40F4601C4058E943BFBEE23540AA574640C161F53F6016AE3F98B0A54016079FC0F467A83FDA13E2C0236B20C00EB1AC3F740744C044427DBF4A39C5C0004D244007A5ACBFF8FF5C3FBDFFA9BF2C43F2BF663858BEB0AB66BF10CA2EC03ADF5CBF01846E4070ABA6C0A96162BFD6B2F43E5DBB543FC1F6C13F858218C032C784C00FD81440D94DF8BF9C2088C06CD54BC035A7C1BF3E94B44054DE2EC08C74613E5656C0BE6E88454056B2953FF4F9F13D002B11BF889CBEBF492EC03FA7B8FE3F9CCDC13F1CFBF63E823EA63E07DF55C0AEC5284059BBA3C05C9D99BF10AE0DBF63704140880FB1BF3FB01D4062790140108ACD3FD0811F3FE84905401F916F3F66552640E6AC29C0D388C1BE6FF76EC0171BAFBF0B22BEBF0C896240E74891BF39FB6CC01569AA40924910C0645C083FB77BEF3F89AFD3BE97EF563E0980F43F16A0774086E64140B31585C0420300BE14ACF6BEB2625040F0ED293FCF68BE3FC66B0BBF4BDBEBBDAF5B02C0C10E9CBE145426C086BC23C05A618240DDC24A3F95A4FA3F4C667DBF2A3502406FDE96C0849F293D2F38CD3FDAC485C03C7000C0A2933FC0B32ECA3E8CBEFB3F5783303F885EF83F1AB897C0D45CC23F1DFC29C05B25353DE7768C3F4C082040DA702A4020D421BEE7DEBABFA0A9A1BF34A0653F36868CC0EE7B563FCAD07B3F9E94DEBE11DF55C0218DB13FC397CEBEA16E35C0B1554BBF3ABC65BF7EB7B5BE08A48840868138BF5629F440DE94EDC025A00D40C3C00A400B73C340FF051ABFFDB052BF38100ABFB2DA3140551C65BF27780040474C01BEB22669C07A4A9AC0B1C2A04056845A3F6B95E2C076054840EA48AFBF7A970240FAA74C3F19AB0240A5ABDCBEFBF097C0EA75BA3F3525FBBF7806E9408AA113C076C047C075351AC0BFE7B540A434DD3EF7AA6B3F916463BFC7F8A83FB176E2BF7292E3BE0B5A11C1FD4EFA3EEE5ECCC00F618D3EA4F3F93FE326F6BD18F103405D5A34BF0A0AFEBEE1967D3F09B17E40A423F1BEF66621402F0903403C3B8F4004B95E400B478D3F0E76193F8189B24080DD2EC0371CB4BF977F96BCA586C6BF6F32244061A2CC3F7AA98BBFF6EC4F401CC290BF2CA94440E15B13BF427C90BF5CED81C09861DF3FF73A79C024852A3F19E6BE3FC0C159403CEEDB3F12BDE9BF9FD889C06D0B91C08EED00BF01BA11C09850203F48A49A3F8FBC7640C5670B40EC98B1405030283E045545BFAE79DA3E6485DDBF894AE6C083637CC047F1B8BE465C4BBF1BA126BF64D7653E949CEDBFEEC79A3FECF6A0404E81A240319F063F4B0E33C0E07ED5BF7DFE62C038610B3D3D5ED6405BE24640973137C02FACBE4069C09DC0A025C5C028CFA4405DD2D73FA028D03F785DD0BFE0CBA64059C18ABED74D0240D7169ABD7698CCBE5C0684C096C91FC0BFF56AC00DD6274034C3914026090040C412C3BF4B538F4041FE2C3FBAD53B3F3B507C40B19459BF5592CA40AC44ADBF69677040F8C0D03F0C382A3FDE3B5840F735D0BF903D78BF029EBA408D5A9240F56E2A3E11027E3E8BA6D63D5BE304C0D8AE95403F0F423F938EF2BFA7B56F3FFE2F1CBF47C4FFBF8B8D47C0E35B454028142FC07C353EBFF142BB3F87A052BDFBF53C40B74CF8BF55133BC0A53B06C00D138B3F0026873F3C136E4002EE62C058301840958F9CBF5B36B4BF034084C006871E3EB59E55C01EBB09C0609D2240BDF1E2C0063F453FEB0D02C1910D71407153B8BF411B39C0271AD03FC616ECBF13A27540CC921F407E1F0EC12F865840F827853F84B078402518AF3FCE3485BF36E258402F3553402BBD8DBD5516C43E65AC32C0BCDF684042C2AA3F4B1C143E0DB699401D6A0BC04ED1373F8B795B40CB8B45BFE06B2DBFBE0596C07DA7C1BD343908C0899D88C01C4E7E3F7ACB94C0633711C04750BEBF6E1D9FBFCA9E6240FDEB1841E89305C0F5188BBFAC4FC7BF5E3C1E408D6DF13F0A5FB23F797FA2BFB60F84C049CB3BC07C0BE4C0C1EF89406ACE51400C8F42C077FAB5403FB39F3FB7414D4008C7ADC009EBDE3C687CC23F56AC583F4C0EC6BF1BFD9B407C499D3E5AAB273F650EEABF3AD58D3FFAE7DABF9C24ABC0"> : tensor<20x20xf32>
    return %cst : tensor<20x20xf32>
  }
  func.func private @expected() -> (tensor<20x20xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x0000803F0000803F000000C00000404000008040000040C00000803F000040C0000000800000E0C0000040400000803F0000008000008040000080BF0000803F000080BF0000004000000080000000C0000000800000E0400000803F000040C0000040400000404000000080000040400000804000000040000000400000C040000080C0000000400000E0C0000000C000000040000040C0000000800000C0C000004040000080BF0000803F000080BF000080BF0000008000000080000000C000000080000080400000A0C0000000800000803F0000803F00000040000000C0000080C000004040000080BF000080C0000040C0000080BF0000C040000000C00000803F0000008000008040000000400000803F00000080000080BF0000004000000040000000400000803F0000803F000040C0000040400000A0C0000080BF0000008000008040000080BF0000404000004040000000400000803F000040400000803F00004040000000C000000080000040C0000080BF000080BF00008040000080BF000040C00000C040000000C00000803F00000040000000800000803F000000400000804000008040000080C00000008000000080000080400000803F000000400000008000000080000000C000000080000000C0000000C00000A0400000803F000000400000008000004040000080C00000803F00000040000080C0000000C0000000C00000803F000000400000803F00000040000080C000000040000000C00000803F00000040000040400000404000000080000080BF000080BF0000803F000080C00000803F0000803F00000080000040C00000004000000080000000C00000008000000080000000800000A04000000080000000410000E0C000004040000040400000E04000000080000000800000008000004040000000800000404000000080000040C0000080C00000C0400000803F0000E0C000008040000080BF000040400000803F0000404000000080000080C000000040000080BF00000041000000C0000040C0000000C00000C0400000803F0000803F0000008000000040000080BF00000080000010C10000803F0000C0C00000803F00000040000000800000404000000080000000800000803F000080400000008000004040000040400000A04000008040000000400000803F0000C040000000C0000080BF00000080000080BF0000404000000040000080BF00008040000080BF0000804000000080000080BF000080C000000040000040C00000803F000000400000804000000040000080BF000080C0000080C000000080000000C00000803F0000004000008040000040400000C0400000803F000000800000803F000080BF0000E0C0000040C00000008000000080000000800000803F000080BF000000400000C0400000C0400000803F000000C0000080BF000040C00000803F0000E04000008040000000C00000C040000080C00000C0C00000C0400000004000000040000080BF0000C04000000080000040400000008000000080000080C0000000C0000040C0000040400000A04000004040000080BF0000A0400000803F0000803F00008040000000800000E040000080BF00008040000000400000803F00008040000080BF000000800000C0400000A0400000803F0000803F0000803F000000C00000A0400000803F000080BF0000803F00000080000080BF000040C000008040000000C000000080000000400000008000004040000080BF000000C0000000C0000000400000004000008040000040C000004040000080BF000080BF000080C00000803F000040C0000000C0000040400000E0C00000803F000000C100008040000080BF000000C000000040000080BF0000804000004040000000C100008040000000400000804000000040000080BF0000804000008040000000800000803F000000C000008040000000400000803F0000A040000000C00000803F000080400000008000000080000080C000000080000000C0000080C00000803F000080C0000000C0000080BF000080BF0000804000002041000000C0000080BF000080BF000040400000004000000040000080BF000080C0000000C00000E0C00000A04000008040000040C00000C04000000040000080400000A0C00000803F000000400000803F000080BF0000A0400000803F0000803F000080BF00000040000080BF0000A0C0"> : tensor<20x20xf32>
    return %cst : tensor<20x20xf32>
  }
}