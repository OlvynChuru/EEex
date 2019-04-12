--[[

Defines all macros used by EEex. Macros give names to assembly bytes, and are used in place
of raw bytes in order to improve the legibility of on-the-fly functions. Unlike labels,
macros have no significance to cross-platform compatibility. More complex assembly solutions
cannot be solved using static byte configurations, thus, macros also support being resolver functions.

EEex_WriteAssembly support =>
1. !macro = Inserts the bytes resolved by the macro into the assembly definition

--]]

for _, macroEntry in ipairs({
	{"add_eax_byte", "83 C0"},
	{"add_eax_dword", "05"},
	{"add_eax_edx", "03 C2"},
	{"add_eax_esi", "03 C6"},
	{"add_ebx_esi", "03 DE"},
	{"add_edi_byte", "83 C7"},
	{"add_edx_eax", "03 D0"},
	{"add_edx_esi", "03 D6"},
	{"add_edx_[esi+byte]", "03 56"},
	{"add_esp_byte", "83 C4"},
	{"add_esp_dword", "81 C4"},
	{"add_esp_eax", "03 E0"},
	{"and_eax_byte", "83 E0"},
	{"and_eax_dword", "25"},
	{"build_stack_frame", "55 8B EC"},
	{"call", "E8"},
	{"call_eax", "FF D0"},
	{"call_[eax+dword]", "FF 90"},
	{"call_[edx+dword]", "FF 92"},
	{"cmove_eax_ebx", "0F 44 C3"},
	{"cmovne_eax_ebx", "0F 45 C3"},
	{"cmovne_eax_edi", "0F 45 C7"},
	{"cmovnz_ebx_eax", "0F 45 D8"},
	{"cmp_byte:[ebp+byte]", "80 7D"},
	{"cmp_eax_byte", "83 F8"},
	{"cmp_eax_dword", "3D"},
	{"cmp_eax_ebx", "3B C3"},
	{"cmp_eax_edx", "3B C2"},
	{"cmp_edi_dword", "81 FF"},
	{"cmp_edx_ebx", "3B D3"},
	{"cmp_esi_dword", "81 FE"},
	{"cmp_esi_ebx", "3B F3"},
	{"cmp_esi_edi", "3B F7"},
	{"cmp_esi_edx", "3B F2"},
	{"cmp_[eax+dword]_byte", "80 B8"},
	{"cmp_[ebp+byte]_byte", "83 7D"},
	{"cmp_[ebp+byte]_dword", "81 7D"},
	{"cmp_[ebp+byte]_ebx", "39 5D"},
	{"cmp_[ebp+dword]_byte", "83 BD"},
	{"cmp_[ebx+dword]_byte", "80 BB"},
	{"cmp_[ecx+byte]_byte", "83 79"},
	{"cmp_[ecx+byte]_esi", "39 71"},
	{"cmp_[ecx+dword]_byte", "83 B9"},
	{"cmp_[esi+dword]_byte", "80 BE"},
	{"dec_eax", "48"},
	{"destroy_stack_frame", "8B E5 5D"},
	{"fild_[esp+byte]", "DB 44 24"},
	{"fild_[esp+dword]", "DB 84 24"},
	{"fild_[esp]", "DB 04 24"},
	{"fstp_qword:[esp+byte]", "DD 5C 24"},
	{"fstp_qword:[esp+dword]", "DD 9C 24"},
	{"fstp_qword:[esp]", "DD 1C 24"},
	{"imul_edx", "F7 EA"},
	{"imul_edx_[esi+byte]", "0F AF 56"},
	{"inc_edi", "47"},
	{"inc_edx", "42"},
	{"inc_esi", "46"},
	{"inc_[ebp+byte]", "FF 45"},
	{"jae_dword", "0F 83"},
	{"ja_dword", "0F 87"},
	{"jb_dword", "0F 82"},
	{"je_byte", "74"},
	{"je_dword", "0F 84"},
	{"jle_byte", "7E"},
	{"jle_dword", "0F 8E"},
	{"jl_byte", "7C"},
	{"jl_dword", "0F 8C"},
	{"jmp_byte", "EB"},
	{"jmp_dword", "E9"},
	{"jmp_[dword]", "FF 25"},
	{"jne_byte", "75"},
	{"jne_dword", "0F 85"},
	{"jnz_dword", "0F 85"},
	{"jz_dword", "0F 84"},
	{"lea_eax_[ebp+byte]", "8D 45"},
	{"lea_eax_[ebp+dword]", "8D 85"},
	{"lea_eax_[ebp]", "8D 45 00"},
	{"lea_eax_[edi+byte]", "8D 47"},
	{"lea_eax_[esi+byte]", "8D 46"},
	{"lea_eax_[esi+dword]", "8D 86"},
	{"lea_ebx_[eax+byte]", "8D 58"},
	{"lea_ebx_[eax+dword]", "8D 98"},
	{"lea_ebx_[eax]", "8D 18"},
	{"lea_ecx_[ebp+byte]", "8D 4D"},
	{"lea_ecx_[ebp+dword]", "8D 8D"},
	{"lea_ecx_[ebp]", "8D 4D 00"},
	{"lea_ecx_[ebx+byte]", "8D 4B"},
	{"lea_ecx_[ecx+eax*4+dword]", "8D 8C 81"},
	{"lea_ecx_[esi+byte]", "8D 4E"},
	{"lea_ecx_[esi+dword]", "8D 8E"},
	{"lea_edi_[eax+byte]", "8D 78"},
	{"lea_edi_[eax+dword]", "8D B8"},
	{"lea_edi_[eax]", "8D 78 00"},
	{"lea_edi_[esi+byte]", "8D 7E"},
	{"movzx_eax_byte:[eax+dword]", "0F B6 80"},
	{"movzx_eax_word:[esi+byte]", "0F B7 46"},
	{"movzx_ecx_word:[esi+byte]", "0F B7 4E"},
	{"movzx_esi_word:[ebp-byte]", "0F B7 75"},
	{"mov_al_[esi+byte]", "8A 46"},
	{"mov_al_[esi+dword]", "8A 86"},
	{"mov_al_[esi]", "8A 46 00"},
	{"mov_bx", "66 BB"},
	{"mov_byte:[ebp+byte]_byte", "C6 45"},
	{"mov_eax", "B8"},
	{"mov_eax_ebx", "8B C3"},
	{"mov_eax_edx", "8B C2"},
	{"mov_eax_esi", "8B C6"},
	{"mov_eax_[dword]", "A1"},
	{"mov_eax_[eax+dword]", "8B 80"},
	{"mov_eax_[ebp+byte]", "8B 45"},
	{"mov_eax_[ebp+dword]", "8B 85"},
	{"mov_eax_[ebp]", "8B 45 00"},
	{"mov_eax_[ebx+byte]", "8B 43"},
	{"mov_eax_[ecx+byte]", "8B 41"},
	{"mov_eax_[ecx+eax*4]", "8B 04 81"},
	{"mov_eax_[ecx]", "8B 01"},
	{"mov_eax_[edi+dword]", "8B 87"},
	{"mov_eax_[edi]", "8B 07"},
	{"mov_eax_[esi+byte]", "8B 46"},
	{"mov_eax_[esi+dword]", "8B 86"},
	{"mov_eax_[esi]", "8B 46 00"},
	{"mov_eax_[esp]", "8B 04 24"},
	{"mov_ebp_esp", "8B EC"},
	{"mov_ebx", "BB"},
	{"mov_ebx_eax", "8B D8"},
	{"mov_ebx_esp", "8B DC"},
	{"mov_ecx_eax", "8B C8"},
	{"mov_ecx_ebx", "8B CB"},
	{"mov_ecx_edi", "8B CF"},
	{"mov_ecx_esi", "8B CE"},
	{"mov_ecx_esp", "8B CC"},
	{"mov_ecx_[dword]", "8B 0D"},
	{"mov_ecx_[eax+dword]", "8B 88"},
	{"mov_ecx_[ebp+byte]", "8B 4D"},
	{"mov_ecx_[ecx+dword]", "8B 89"},
	{"mov_ecx_[ecx]", "8B 09"},
	{"mov_ecx_[edx+byte]", "8B 4A"},
	{"mov_ecx_[edx+dword]", "8B 8A"},
	{"mov_ecx_[edx]", "8B 4A 00"},
	{"mov_ecx_[esi+byte]", "8B 4E"},
	{"mov_ecx_[esp+byte]", "8B 4C 24"},
	{"mov_edi", "BF"},
	{"mov_edi_eax", "8B F8"},
	{"mov_edi_ecx", "8B F9"},
	{"mov_edi_esp", "8B FC"},
	{"mov_edi_[eax+dword]", "8B B8"},
	{"mov_edi_[ebp+byte]", "8B 7D"},
	{"mov_edi_[ebp+dword]", "8B BD"},
	{"mov_edi_[ebp]", "8B 7D 00"},
	{"mov_edi_[esi+byte]", "8B 7E"},
	{"mov_edx", "BA"},
	{"mov_edx_eax", "8B D0"},
	{"mov_edx_[eax+dword]", "8B 90"},
	{"mov_edx_[ebx+byte]", "8B 53"},
	{"mov_edx_[ebx+dword]", "8B 93"},
	{"mov_edx_[ebx]", "8B 53 00"},
	{"mov_edx_[ecx+byte]", "8B 51"},
	{"mov_edx_[ecx+edi*4]", "8B 14 B9"},
	{"mov_edx_[ecx]", "8B 11"},
	{"mov_edx_[edi+byte]", "8B 57"},
	{"mov_edx_[edi+dword]", "8B 97"},
	{"mov_edx_[edi]", "8B 57 00"},
	{"mov_edx_[edx+byte]", "8B 52"},
	{"mov_edx_[edx+dword]", "8B 92"},
	{"mov_edx_[edx]", "8B 52 00"},
	{"mov_edx_[esi+byte]", "8B 56"},
	{"mov_esi", "BE"},
	{"mov_esi_eax", "8B F0"},
	{"mov_esi_ecx", "8B F1"},
	{"mov_esi_[eax+dword]", "8B B0"},
	{"mov_esi_[esi+byte]", "8B 76"},
	{"mov_esi_[esi]", "8B 36"},
	{"mov_esp_[ebp+byte]", "8B 65"},
	{"mov_esp_[ebp+dword]", "8B A5"},
	{"mov_esp_[ebp]", "8B 65 00"},
	{"mov_[dword]_eax", "A3"},
	{"mov_[dword]_esi", "89 35"},
	{"mov_[eax+dword]_edx", "89 90"},
	{"mov_[ebp+byte]_dword", "C7 45"},
	{"mov_[ebp+byte]_eax", "89 45"},
	{"mov_[ebp+byte]_ecx", "89 4D"},
	{"mov_[ebp+byte]_edi", "89 7D"},
	{"mov_[ebp+byte]_esp", "89 65"},
	{"mov_[ebp+dword]_dword", "C7 85"},
	{"mov_[ebp+dword]_edi", "89 BD"},
	{"mov_[ebp+dword]_esp", "89 A5"},
	{"mov_[ebp]_dword", "C7 45 00"},
	{"mov_[ebp]_edi", "89 7D 00"},
	{"mov_[ebp]_esp", "89 65 00"},
	{"mov_[ecx+dword]_dword", "C7 81"},
	{"mov_[ecx+dword]_eax", "89 81"},
	{"mov_[ecx+dword]_edx", "89 91"},
	{"mov_[ecx+eax*4]_edx", "89 14 81"},
	{"mov_[ecx+edi*4]_edx", "89 14 B9"},
	{"mov_[edi+byte]_al", "88 47"},
	{"mov_[edi+byte]_byte", "C6 47"},
	{"mov_[edi+byte]_dword", "C7 47"},
	{"mov_[edi+byte]_eax", "89 47"},
	{"mov_[edi+dword]_al", "88 87"},
	{"mov_[edi+dword]_ax", "66 89 87"},
	{"mov_[edi+dword]_bx", "66 89 9F"},
	{"mov_[edi+dword]_byte", "C6 87"},
	{"mov_[edi+dword]_dword", "C7 87"},
	{"mov_[edi+dword]_eax", "89 87"},
	{"mov_[edi+dword]_edx", "89 97"},
	{"mov_[edi]_al", "88 07"},
	{"mov_[edi]_byte", "C6 07"},
	{"mov_[edi]_dword", "C7 47 00"},
	{"mov_[edi]_eax", "89 07"},
	{"mov_[edx+byte]_eax", "89 42"},
	{"mov_[esi+byte]_dword", "C7 46"},
	{"mov_[esi+byte]_eax", "89 46"},
	{"mov_[esi+dword]_ax", "66 89 86"},
	{"mov_[esi+dword]_dword", "C7 86"},
	{"mov_[esi+dword]_eax", "89 86"},
	{"mov_[esi]_dword", "C7 06"},
	{"mov_[esp+byte]_ecx", "89 4C 24"},
	{"nop", "90"},
	{"pop_all_registers", "5F 5E 5A 59 5B 58"},
	{"pop_complete_state", "5F 5E 5A 59 5B 58 5D"},
	{"pop_eax", "58"},
	{"pop_ebp", "5D"},
	{"pop_ebx", "5B"},
	{"pop_ecx", "59"},
	{"pop_edi", "5F"},
	{"pop_esi", "5E"},
	{"pop_registers", "5F 5E 5A 59 5B"},
	{"pop_state", "5F 5E 5A 59 5B 5D"},
	{"push_all_registers", "50 53 51 52 56 57"},
	{"push_byte", "6A"},
	{"push_complete_state", "55 8B EC 50 53 51 52 56 57"},
	{"push_dword", "68"},
	{"push_eax", "50"},
	{"push_ebp", "55"},
	{"push_ebx", "53"},
	{"push_ecx", "51"},
	{"push_edi", "57"},
	{"push_edx", "52"},
	{"push_esi", "56"},
	{"push_registers", "53 51 52 56 57"},
	{"push_state", "55 8B EC 53 51 52 56 57"},
	{"push_[dword]", "FF 35"},
	{"push_[ebp+byte]", "FF 75"},
	{"push_[ebp+dword]", "FF B5"},
	{"push_[ebp]", "FF 75 00"},
	{"push_[ecx+byte]", "FF 71"},
	{"push_[ecx]", "FF 31"},
	{"push_[edi+byte]", "FF 77"},
	{"push_[edi+dword]", "FF B7"},
	{"push_[edx+byte]", "FF 72"},
	{"push_[esi+byte]", "FF 76"},
	{"push_[esi+dword]", "FF B6"},
	{"push_[esp]", "FF 34 24"},
	{"restore_stack_frame", "5F 5E 5A 59 5B 8B E5 5D"},
	{"ret", "C3"},
	{"ret_word", "C2"},
	{"sar_edx", "C1 FA"},
	{"shl_edx", "C1 E2"},
	{"shr_eax", "C1 E8"},
	{"sub_eax_byte", "83 E8"},
	{"sub_eax_dword", "2D"},
	{"sub_edi_dword", "81 EF"},
	{"sub_esp_byte", "83 EC"},
	{"sub_esp_dword", "81 EC"},
	{"sub_esp_eax", "2B E0"},
	{"sub_esp_edx", "2B E2"},
	{"test_al_al", "84 C0"},
	{"test_eax_eax", "85 C0"},
	{"test_ecx_ecx", "85 C9"},
	{"test_edi_edi", "85 FF"},
	{"test_edx_edx", "85 D2"},
	{"test_esi_esi", "85 F6"},
	{"test_[ecx+byte]_byte", "F6 41"},
	{"test_[ecx+dword]_byte", "F6 81"},
	{"test_[ecx]_byte", "F6 41 00"},
	{"test_[edi+byte]_byte", "F6 47"},
	{"xor_eax_eax", "33 C0"},
	{"xor_ebx_ebx", "33 DB"},
	{"xor_edi_edi", "33 FF"},
	{"xor_esi_esi", "33 F6"},
})
do
	local macroName = macroEntry[1]
	local macroValue = macroEntry[2]
	EEex_DefineAssemblyMacro(macroName, macroValue)
end
