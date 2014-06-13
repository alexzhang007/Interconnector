//Author      : Alex Zhang (cgzhangwei@gmail.com)
//Date        : Jun. 13. 2014
//Description : Implement the memory_access_interconnector(MAI)

module mem_access_interconnector (
clk,
resetn,
//Instruction Fetech (IF)
iIF_ValidRd,
iIF_AddrRd,
iIF_TagRd,
iIF_IdRd,
iIF_LenRd,
iIF_QoSRd,
iIF_ReadyRd,
oIF_ValidRsp,
oIF_TagRsp,
oIF_DataRsp,
oIF_StatusRsp,
oIF_EoD,
iIF_ReadyRsp,
iIF_ValidWr,
iIF_AddrWr,
iIF_TagWr,
iIF_IdWr,
iIF_LenWr,
iIF_QoSWr,
oIF_ReadyWr,
iIF_DataWr,
iIF_MaskWr,
iIF_EoD,

//Data Memory (DM)
iDM_ValidRd,
iDM_AddrRd,
iDM_TagRd,
iDM_IdRd,
iDM_LenRd,
iDM_QoSRd,
iDM_ReadyRd,
oDM_ValidRsp,
oDM_TagRsp,
oDM_DataRsp,
oDM_StatusRsp,
oDM_EoD,
iDM_ReadyRsp,
iDM_ValidWr,
iDM_AddrWr,
iDM_TagWr,
iDM_IdWr,
iDM_LenWr,
iDM_QoSWr,
oDM_ReadyWr,
iDM_DataWr,
iDM_MaskWr,
iDM_EoD,

//Memory Access Controller (MAC)
iMAC_ValidRd,
iMAC_AddrRd,
iMAC_TagRd,
iMAC_IdRd,
iMAC_LenRd,
iMAC_QoSRd,
iMAC_ReadyRd,
oMAC_ValidRsp,
oMAC_TagRsp,
oMAC_DataRsp,
oMAC_StatusRsp,
oMAC_EoD,
iMAC_ReadyRsp,
iMAC_ValidWr,
iMAC_AddrWr,
iMAC_TagWr,
iMAC_IdWr,
iMAC_LenWr,
iMAC_QoSWr,
oMAC_ReadyWr,
iMAC_DataWr,
iMAC_MaskWr,
iMAC_EoD
);
input  clk;
input  resetn;

//Instruction Fetech (IF)
input  iIF_ValidRd;
input  iIF_AddrRd;
input  iIF_TagRd;
input  iIF_IdRd;
input  iIF_LenRd;
input  iIF_QoSRd;
input  iIF_ReadyRd;
output oIF_ValidRsp;
output oIF_TagRsp;
output oIF_DataRsp;
output oIF_StatusRsp;
output oIF_EoD;
input  iIF_ReadyRsp;
input  iIF_ValidWr;
input  iIF_AddrWr;
input  iIF_TagWr;
input  iIF_IdWr;
input  iIF_LenWr;
input  iIF_QoSWr;
output oIF_ReadyWr;
input  iIF_DataWr;
input  iIF_MaskWr;
input  iIF_EoD;

//Data Memory (DM)
input  iDM_ValidRd;
input  iDM_AddrRd;
input  iDM_TagRd;
input  iDM_IdRd;
input  iDM_LenRd;
input  iDM_QoSRd;
input  iDM_ReadyRd;
output oDM_ValidRsp;
output oDM_TagRsp;
output oDM_DataRsp;
output oDM_StatusRsp;
output oDM_EoD;
input  iDM_ReadyRsp;
input  iDM_ValidWr;
input  iDM_AddrWr;
input  iDM_TagWr;
input  iDM_IdWr;
input  iDM_LenWr;
input  iDM_QoSWr;
output oDM_ReadyWr;
input  iDM_DataWr;
input  iDM_MaskWr;
input  iDM_EoD;

//Memory Access Controller (MAC)
input  iMAC_ValidRd;
input  iMAC_AddrRd;
input  iMAC_TagRd;
input  iMAC_IdRd;
input  iMAC_LenRd;
input  iMAC_QoSRd;
input  iMAC_ReadyRd;
output oMAC_ValidRsp;
output oMAC_TagRsp;
output oMAC_DataRsp;
output oMAC_StatusRsp;
output oMAC_EoD;
input  iMAC_ReadyRsp;
input  iMAC_ValidWr;
input  iMAC_AddrWr;
input  iMAC_TagWr;
input  iMAC_IdWr;
input  iMAC_LenWr;
input  iMAC_QoSWr;
output oMAC_ReadyWr;
input  iMAC_DataWr;
input  iMAC_MaskWr;
input  iMAC_EoD;


//Instruction Fetech (IF)
wire         iIF_ValidRd;
wire [31:0]  iIF_AddrRd;
wire [3:0]   iIF_TagRd;
wire [2:0]   iIF_IdRd;
wire [1:0]   iIF_LenRd;
wire [3:0]   iIF_QoSRd;
wire         iIF_ReadyRd;
wire         oIF_ValidRsp;
wire [3:0]   oIF_TagRsp;
wire [31:0]  oIF_DataRsp;
wire [1:0]   oIF_StatusRsp;
wire         oIF_EoD;
wire         iIF_ReadyRsp;
wire         iIF_ValidWr;
wire [31:0]  iIF_AddrWr;
wire [3:0]   iIF_TagWr;
wire [2:0]   iIF_IdWr;
wire [1:0]   iIF_LenWr;
wire [3:0]   iIF_QoSWr;
wire         oIF_ReadyWr;
wire [31:0]  iIF_DataWr;
wire [3:0]   iIF_MaskWr;
wire         iIF_EoD;

//Data Memory (DM)
wire         iDM_ValidRd;
wire [31:0]  iDM_AddrRd;
wire [3:0]   iDM_TagRd;
wire [2:0]   iDM_IdRd;
wire [1:0]   iDM_LenRd;
wire [3:0]   iDM_QoSRd;
wire         iDM_ReadyRd;
wire         oDM_ValidRsp;
wire [3:0]   oDM_TagRsp;
wire [31:0]  oDM_DataRsp;
wire [1:0]   oDM_StatusRsp;
wire         oDM_EoD;
wire         iDM_ReadyRsp;
wire         iDM_ValidWr;
wire [31:0]  iDM_AddrWr;
wire [3:0]   iDM_TagWr;
wire [2:0]   iDM_IdWr;
wire [1:0]   iDM_LenWr;
wire [3:0]   iDM_QoSWr;
wire         oDM_ReadyWr;
wire [31:0]  iDM_DataWr;
wire [3:0]   iDM_MaskWr;
wire         iDM_EoD;

//Memory Access Controller (MAC)
wire         iMAC_ValidRd;
wire [31:0]  iMAC_AddrRd;
wire [3:0]   iMAC_TagRd;
wire [2:0]   iMAC_IdRd;
wire [1:0]   iMAC_LenRd;
wire [3:0]   iMAC_QoSRd;
wire         iMAC_ReadyRd;
wire         oMAC_ValidRsp;
wire [3:0]   oMAC_TagRsp;
wire [31:0]  oMAC_DataRsp;
wire [1:0]   oMAC_StatusRsp;
wire         oMAC_EoD;
wire         iMAC_ReadyRsp;
wire         iMAC_ValidWr;
wire [31:0]  iMAC_AddrWr;
wire [3:0]   iMAC_TagWr;
wire [2:0]   iMAC_IdWr;
wire [1:0]   iMAC_LenWr;
wire [3:0]   iMAC_QoSWr;
wire         oMAC_ReadyWr;
wire [31:0]  iMAC_DataWr;
wire [3:0]   iMAC_MaskWr;
wire         iMAC_EoD;







endmodule 
