// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DBK/BrickRubble"
{
	Properties
	{
		_ColorTheme("Color Theme", 2D) = "white" {}
		_PaintRange("Paint Range", Range( 0 , 1)) = 0
		_PaintSmooth("Paint Smooth", Range( 0 , 0.1)) = 0
		[PerRendererData]_ColorSelect("ColorSelect", Int) = 0
		_BakedNM("Baked NM", 2D) = "bump" {}
		_DetailsNM("Details NM", 2D) = "bump" {}
		_DetailsNMScale("Details NM Scale", Range( 0 , 1)) = 0
		_DetailsTiling("Details Tiling", Range( 1 , 8)) = 0
		_MainTex("Mask A", 2D) = "white" {}
		[MaxGay]_DirtSmooth("Dirt Smooth", Range( 0 , 1)) = 0
		_DirtRange("Dirt Range", Range( 0 , 1)) = 0
		_DirtContrast("Dirt Contrast", Range( 0 , 2)) = 0
		_DirtBrightness("Dirt Brightness", Range( 0 , 1)) = 0
		_MainSmoothness("Main Smoothness", Range( 0 , 1)) = 0
		_PaintSmoothness("Paint Smoothness", Range( 0 , 1)) = 0
		_MaskB("Mask B", 2D) = "white" {}
		[Toggle(_USECUSTOMCOLOR_ON)] _UseCustomColor("Use Custom Color", Float) = 0
		_CustomColor("Custom Color", Int) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_BakedNMScale("Baked NM Scale", Range( 1 , 2)) = 0
		_Color("Color", Color) = (1,1,1,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 4.6
		#pragma shader_feature _USECUSTOMCOLOR_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _BakedNM;
		uniform float4 _BakedNM_ST;
		uniform float _BakedNMScale;
		uniform sampler2D _DetailsNM;
		uniform float _DetailsTiling;
		uniform float _DetailsNMScale;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _ColorTheme;
		uniform int _ColorSelect;
		uniform int _CustomColor;
		uniform sampler2D _MaskB;
		uniform float _PaintRange;
		uniform float _PaintSmooth;
		uniform float _DirtBrightness;
		uniform float _DirtRange;
		uniform float _DirtSmooth;
		uniform float _DirtContrast;
		uniform float4 _Color;
		uniform float _MainSmoothness;
		uniform float _PaintSmoothness;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BakedNM = i.uv_texcoord * _BakedNM_ST.xy + _BakedNM_ST.zw;
			float2 temp_cast_0 = (_DetailsTiling).xx;
			float2 uv_TexCoord89 = i.uv_texcoord * temp_cast_0;
			float2 TilingAmount91 = uv_TexCoord89;
			float3 Normals94 = BlendNormals( UnpackScaleNormal( tex2D( _BakedNM, uv_BakedNM ), _BakedNMScale ) , UnpackScaleNormal( tex2D( _DetailsNM, TilingAmount91 ), _DetailsNMScale ) );
			o.Normal = Normals94;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode133 = tex2D( _MainTex, uv_MainTex );
			float Mask_A_Red134 = tex2DNode133.r;
			float4 temp_cast_1 = (Mask_A_Red134).xxxx;
			half2 _ColorsNumber = half2(0,-0.1);
			#ifdef _USECUSTOMCOLOR_ON
				float staticSwitch72 = (float)_CustomColor;
			#else
				float staticSwitch72 = (float)_ColorSelect;
			#endif
			float2 temp_output_74_0 = ( half2( 0.015625,0 ) * staticSwitch72 );
			float2 appendResult79 = (float2(temp_output_74_0.x , 0.19));
			float2 uv_TexCoord80 = i.uv_texcoord * _ColorsNumber + appendResult79;
			float4 Color383 = tex2D( _ColorTheme, uv_TexCoord80 );
			float2 uv_TexCoord77 = i.uv_texcoord * _ColorsNumber + temp_output_74_0;
			float4 Color1UV381 = tex2D( _ColorTheme, uv_TexCoord77 );
			float4 tex2DNode55 = tex2D( _MaskB, uv_TexCoord89 );
			float Mask_B_Red56 = tex2DNode55.r;
			float3 temp_cast_5 = (( 1.0 - Mask_B_Red56 )).xxx;
			float Mask_B_Green57 = tex2DNode55.g;
			float VertexGreen63 = i.vertexColor.g;
			float3 temp_cast_6 = (( Mask_B_Green57 * VertexGreen63 )).xxx;
			float Mask_A_Green137 = tex2DNode133.g;
			float PaintSelection119 = ( saturate( ( 1.0 - ( ( distance( temp_cast_5 , temp_cast_6 ) - _PaintRange ) / max( _PaintSmooth , 1E-05 ) ) ) ) * Mask_A_Green137 );
			float4 lerpResult126 = lerp( Color383 , Color1UV381 , PaintSelection119);
			float Mask_A_Blue135 = tex2DNode133.b;
			float4 lerpResult1 = lerp( temp_cast_1 , lerpResult126 , ( 1.0 - Mask_A_Blue135 ));
			float2 appendResult87 = (float2(temp_output_74_0.x , 0.5));
			float2 uv_TexCoord85 = i.uv_texcoord * _ColorsNumber + appendResult87;
			float4 Color2UV386 = tex2D( _ColorTheme, uv_TexCoord85 );
			float Mask_B_Alpha59 = tex2DNode55.a;
			float VertexRed62 = i.vertexColor.r;
			float3 temp_cast_8 = (( VertexRed62 * Mask_B_Alpha59 )).xxx;
			float3 temp_cast_9 = (( 1.0 - Mask_B_Red56 )).xxx;
			float clampResult51 = clamp( ( saturate( ( 1.0 - ( ( distance( temp_cast_8 , temp_cast_9 ) - _DirtRange ) / max( _DirtSmooth , 1E-05 ) ) ) ) * _DirtContrast ) , 0.0 , 1.0 );
			float DirtSelection52 = clampResult51;
			float4 lerpResult68 = lerp( lerpResult1 , ( ( Color2UV386 * Mask_B_Alpha59 ) * _DirtBrightness ) , DirtSelection52);
			float4 Albedo143 = ( lerpResult68 * Mask_B_Alpha59 );
			o.Albedo = ( Albedo143 * _Color ).rgb;
			float Smoothnes163 = ( ( ( Mask_A_Red134 * _MainSmoothness ) + ( _PaintSmoothness * PaintSelection119 ) ) * ( 1.0 - DirtSelection52 ) );
			o.Smoothness = Smoothnes163;
			o.Alpha = 1;
			float Mask_A_Alpha136 = tex2DNode133.a;
			clip( Mask_A_Alpha136 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18935
2560;133;1920;1132;-1080.328;151.6388;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;53;-2253.833,777.3105;Inherit;False;1178.235;453.5738;Comment;8;91;58;57;59;56;55;89;90;Mask B;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-2248.326,892.4756;Inherit;False;Property;_DetailsTiling;Details Tiling;7;0;Create;True;0;0;0;False;0;False;0;5;1;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;89;-1962.119,863.2635;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;69;-1575.011,-1332.659;Inherit;False;2202.638;833.9692;Comment;18;87;86;85;84;83;82;81;80;79;78;77;76;75;74;73;72;71;70;Color Selection;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;60;-2824.438,772.58;Inherit;False;485.4663;265.6519;Comment;3;63;62;61;Vertex Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;55;-1689.782,842.0186;Inherit;True;Property;_MaskB;Mask B;15;0;Create;True;0;0;0;False;0;False;-1;None;5b71a3cf759201643b7d66aa9084dbd4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;70;-1516.417,-1061.846;Inherit;False;Property;_ColorSelect;ColorSelect;3;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.VertexColorNode;61;-2774.438,822.58;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;71;-1533.295,-906.8967;Inherit;False;Property;_CustomColor;Custom Color;17;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.Vector2Node;73;-1314.66,-1236.519;Half;False;Constant;_NumberOfColors;NumberOfColors;19;0;Create;True;0;0;0;False;1;;False;0.015625,0;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;132;-956.0053,779.848;Inherit;False;708.3281;446.6394;Comment;5;137;136;135;134;133;Mask A;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-1357.101,837.7975;Inherit;False;Mask_B_Red;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;72;-1313.295,-942.8968;Inherit;False;Property;_UseCustomColor;Use Custom Color;16;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-2547.149,921.2321;Inherit;False;VertexGreen;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;111;-974.6368,1496.509;Inherit;False;1404.351;589.2565;Comment;11;122;121;120;119;118;117;115;114;113;112;141;Paint Selection;0.764151,0.3913952,0.1117391,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;-1351.853,938.4694;Inherit;False;Mask_B_Green;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;133;-906.0053,829.848;Inherit;True;Property;_MainTex;Mask A;8;0;Create;False;0;0;0;False;0;False;-1;None;248f2238564ce0943aaa20442904dc0a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-952.3636,-1107.326;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-924.6368,1645.63;Inherit;False;63;VertexGreen;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-2554.733,826.231;Inherit;False;VertexRed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-919.9698,1545.509;Inherit;False;57;Mask_B_Green;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-911.6368,1763.63;Inherit;False;56;Mask_B_Red;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-1355.752,1125.084;Inherit;False;Mask_B_Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;35;502.868,1244.016;Inherit;False;1734.791;609.588;Comment;12;52;51;50;48;49;47;46;40;45;36;41;39;Dirt Selection;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;610.2483,1443.998;Inherit;False;62;VertexRed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;79;-784.8315,-632.8185;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.19;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;-545.2802,933.2969;Inherit;False;Mask_A_Green;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;600.2472,1538.998;Inherit;False;59;Mask_B_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;626.3856,1301.535;Inherit;False;56;Mask_B_Red;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;115;-664.2256,1741.088;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-642.4618,1576.156;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;75;-949.6666,-1305.723;Half;False;Constant;_ColorsNumber;ColorsNumber;19;0;Create;True;0;0;0;False;1;;False;0,-0.1;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;87;-786.3695,-827.753;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-760.1808,1995.766;Inherit;False;Property;_PaintSmooth;Paint Smooth;2;0;Create;True;0;0;0;False;0;False;0;0.06668227;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-760.0119,1899.403;Inherit;False;Property;_PaintRange;Paint Range;1;0;Create;True;0;0;0;False;0;False;0;0.64755;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;80;-491.1853,-669.6181;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;117;-372.9296,1576.103;Inherit;False;Color Mask;-1;;43;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.17;False;5;FLOAT;0.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;829.2472,1439.998;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;76;-512.2083,-1111.84;Inherit;True;Property;_ColorTheme;Color Theme;0;0;Create;False;0;0;0;False;0;False;a4b54f4a931b12047a9252ab1e0b62a0;a4b54f4a931b12047a9252ab1e0b62a0;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;141;-252.446,1783.203;Inherit;False;137;Mask_A_Green;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;85;-492.2032,-852.1651;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;77;-512.7734,-1259.538;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;47;835.2473,1679.999;Inherit;False;Property;_DirtSmooth;Dirt Smooth;9;0;Create;True;0;0;0;False;1;MaxGay;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;851.2473,1615.999;Inherit;False;Property;_DirtRange;Dirt Range;10;0;Create;True;0;0;0;False;0;False;0;0.3424187;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;878.3857,1304.534;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;1299.247,1631.999;Inherit;False;Property;_DirtContrast;Dirt Contrast;11;0;Create;True;0;0;0;False;0;False;0;1.04;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-20.56276,1578.975;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;82;-69.07608,-747.5679;Inherit;True;Property;_TextureSample5;Texture Sample 5;32;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;84;-69.81314,-977.7667;Inherit;True;Property;_Texture4;Texture4;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;78;-87.66006,-1259.433;Inherit;True;Property;_TextureSample2;Texture Sample 2;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;48;1267.247,1407.998;Inherit;False;Color Mask;-1;;44;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.17;False;5;FLOAT;0.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;344.4669,-1250.308;Inherit;False;Color1UV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;383.2949,-742.2154;Inherit;False;Color3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;135;-523.0951,1007.04;Inherit;False;Mask_A_Blue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;1571.248,1423.998;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;86;366.45,-974.7317;Inherit;False;Color2UV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;188.7159,1578.425;Inherit;False;PaintSelection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;147;-933.6428,-227.6976;Inherit;False;571.3657;341;Cement;4;140;139;7;1;Cement;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;145;-1562.207,-204.4908;Inherit;False;527.8848;350.113;Comment;4;126;88;128;127;Bricks Lerp;0.8584906,0.6084247,0.08503916,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;148;-182.3878,-225.2304;Inherit;False;628.7346;681.212;Comment;7;65;66;67;130;129;64;68;Dirt;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;-544.3202,837.297;Inherit;False;Mask_A_Red;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;-133.8579,40.0077;Inherit;False;86;Color2UV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-154.4878,155.5161;Inherit;False;59;Mask_B_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;-1499.323,23.62218;Inherit;False;119;PaintSelection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-1493.323,-68.37779;Inherit;False;81;Color1UV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;51;1763.247,1407.998;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;140;-872.5089,-29.91382;Inherit;False;135;Mask_A_Blue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;88;-1491.207,-157.4908;Inherit;False;83;Color3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;126;-1218.323,-144.3778;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;80.21213,115.6159;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-113.1507,340.9817;Inherit;False;Property;_DirtBrightness;Dirt Brightness;12;0;Create;True;0;0;0;False;0;False;0;0.591684;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-862.9315,-181.3057;Inherit;False;134;Mask_A_Red;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;1971.246,1407.998;Inherit;False;DirtSelection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;7;-668.528,-6.094521;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;149;943.3696,-1267.122;Inherit;False;1663.547;695.5518;Smoothness;11;163;162;160;159;157;156;154;165;167;166;168;Smoothness;0.764151,0.2342916,0.6549128,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;154;1621.841,-695.9734;Inherit;False;119;PaintSelection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1;-552.4625,-168.2288;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;156;1079.862,-1104.907;Inherit;False;Property;_MainSmoothness;Main Smoothness;13;0;Create;True;0;0;0;False;0;False;0;0.1068977;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;157;1550.841,-863.9733;Inherit;False;Property;_PaintSmoothness;Paint Smoothness;14;0;Create;True;0;0;0;False;0;False;0;0.1573163;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;-1668.829,1103.683;Inherit;False;TilingAmount;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;165;1125.949,-1193.88;Inherit;False;134;Mask_A_Red;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;10.79655,-59.24835;Inherit;False;52;DirtSelection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;146;735.8494,-234.1888;Inherit;False;358.7912;277.7583;Overlay;2;131;32;Details Overlay;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;96;-2477.818,1445.233;Inherit;False;1380.596;532.9998;Comment;7;25;93;21;5;22;94;169;Normals;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;205.6882,257.98;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;68;273.3473,-166.2304;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;743.0397,-85.75332;Inherit;False;59;Mask_B_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2422.818,1861.233;Inherit;False;Property;_DetailsNMScale;Details NM Scale;6;0;Create;True;0;0;0;False;0;False;0;0.2764139;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;159;1516.862,-1145.907;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-2325.693,1737.621;Inherit;False;91;TilingAmount;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;1868.841,-863.9733;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;167;1941.254,-747.2681;Inherit;False;52;DirtSelection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;169;-2372.607,1584.546;Inherit;False;Property;_BakedNMScale;Baked NM Scale;19;0;Create;True;0;0;0;False;0;False;0;1.235294;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-2085.818,1735.233;Inherit;True;Property;_DetailsNM;Details NM;5;0;Create;True;0;0;0;False;0;False;-1;4ea5083d09e1aa747b5ad9a32ad2cb74;4ea5083d09e1aa747b5ad9a32ad2cb74;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;162;1949.128,-1140.884;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;168;2138.308,-856.5795;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-2095.818,1489.233;Inherit;True;Property;_BakedNM;Baked NM;4;0;Create;True;0;0;0;False;0;False;-1;ba4ccd7b6ac429248a25cf723ce076f3;ba4ccd7b6ac429248a25cf723ce076f3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;957.9957,-175.896;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;22;-1713.737,1500.28;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;166;2202.254,-1134.268;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;143;1224.671,-176.4557;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;144;1641.416,277.681;Inherit;False;143;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;163;2367.899,-1140.107;Inherit;False;Smoothnes;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-556.6761,1140.488;Inherit;False;Mask_A_Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-1429.419,1505.359;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;171;1654.01,-31.2835;Inherit;False;Property;_Color;Color;20;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;142;1620.354,620.0516;Inherit;False;136;Mask_A_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;164;1603.208,488.7929;Inherit;False;163;Smoothnes;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;1813.93,324.3795;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;1623.634,375.8901;Inherit;False;94;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-1333.154,1018.269;Inherit;False;Mask_B_Blue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1955.339,367.41;Float;False;True;-1;6;;0;0;Standard;DBK/BrickRubble;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;18;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;89;0;90;0
WireConnection;55;1;89;0
WireConnection;56;0;55;1
WireConnection;72;1;70;0
WireConnection;72;0;71;0
WireConnection;63;0;61;2
WireConnection;57;0;55;2
WireConnection;74;0;73;0
WireConnection;74;1;72;0
WireConnection;62;0;61;1
WireConnection;59;0;55;4
WireConnection;79;0;74;0
WireConnection;137;0;133;2
WireConnection;115;0;122;0
WireConnection;113;0;120;0
WireConnection;113;1;121;0
WireConnection;87;0;74;0
WireConnection;80;0;75;0
WireConnection;80;1;79;0
WireConnection;117;1;113;0
WireConnection;117;3;115;0
WireConnection;117;4;112;0
WireConnection;117;5;114;0
WireConnection;45;0;36;0
WireConnection;45;1;41;0
WireConnection;85;0;75;0
WireConnection;85;1;87;0
WireConnection;77;0;75;0
WireConnection;77;1;74;0
WireConnection;40;0;39;0
WireConnection;118;0;117;0
WireConnection;118;1;141;0
WireConnection;82;0;76;0
WireConnection;82;1;80;0
WireConnection;84;0;76;0
WireConnection;84;1;85;0
WireConnection;78;0;76;0
WireConnection;78;1;77;0
WireConnection;48;1;40;0
WireConnection;48;3;45;0
WireConnection;48;4;46;0
WireConnection;48;5;47;0
WireConnection;81;0;78;0
WireConnection;83;0;82;0
WireConnection;135;0;133;3
WireConnection;50;0;48;0
WireConnection;50;1;49;0
WireConnection;86;0;84;0
WireConnection;119;0;118;0
WireConnection;134;0;133;1
WireConnection;51;0;50;0
WireConnection;126;0;88;0
WireConnection;126;1;128;0
WireConnection;126;2;127;0
WireConnection;64;0;66;0
WireConnection;64;1;67;0
WireConnection;52;0;51;0
WireConnection;7;0;140;0
WireConnection;1;0;139;0
WireConnection;1;1;126;0
WireConnection;1;2;7;0
WireConnection;91;0;89;0
WireConnection;129;0;64;0
WireConnection;129;1;130;0
WireConnection;68;0;1;0
WireConnection;68;1;129;0
WireConnection;68;2;65;0
WireConnection;159;0;165;0
WireConnection;159;1;156;0
WireConnection;160;0;157;0
WireConnection;160;1;154;0
WireConnection;21;1;93;0
WireConnection;21;5;25;0
WireConnection;162;0;159;0
WireConnection;162;1;160;0
WireConnection;168;0;167;0
WireConnection;5;5;169;0
WireConnection;32;0;68;0
WireConnection;32;1;131;0
WireConnection;22;0;5;0
WireConnection;22;1;21;0
WireConnection;166;0;162;0
WireConnection;166;1;168;0
WireConnection;143;0;32;0
WireConnection;163;0;166;0
WireConnection;136;0;133;4
WireConnection;94;0;22;0
WireConnection;170;0;144;0
WireConnection;170;1;171;0
WireConnection;58;0;55;3
WireConnection;0;0;170;0
WireConnection;0;1;95;0
WireConnection;0;4;164;0
WireConnection;0;10;142;0
ASEEND*/
//CHKSM=10922CD4F6964EDCD88E8B37A2EA31499A115C36