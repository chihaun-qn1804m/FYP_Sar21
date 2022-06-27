// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DBK/Insulation"
{
	Properties
	{
		_MainTex("Color Theme", 2D) = "white" {}
		[PerRendererData]_ColorSelect("ColorSelect", Int) = 0
		_InsulationDarkness("Insulation Darkness", Range( 0 , 1)) = 0
		_Normals("Normals", 2D) = "bump" {}
		_NormalsScale("Normals Scale", Range( 0 , 2)) = 0
		_InsulationMask("Insulation Mask", 2D) = "white" {}
		_DirtOpacity("Dirt Opacity", Range( 0 , 1)) = 0
		_DirtRange("Dirt Range", Range( 0 , 1)) = 0
		_DirtSmooth("Dirt Smooth", Range( 0 , 1)) = 0
		_DirtMultiplier("Dirt Multiplier", Range( 0 , 2)) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Mask("Mask", Range( 0 , 1)) = 0
		_Color("Color", Color) = (1,1,1,1)
		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 4.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float2 uv4_texcoord4;
		};

		uniform sampler2D _Normals;
		uniform float4 _Normals_ST;
		uniform float _NormalsScale;
		uniform sampler2D _InsulationMask;
		uniform float4 _InsulationMask_ST;
		uniform float _InsulationDarkness;
		uniform sampler2D _MainTex;
		uniform int _ColorSelect;
		uniform float _DirtMultiplier;
		uniform float _DirtRange;
		uniform float _DirtSmooth;
		uniform float _DirtOpacity;
		uniform float4 _Color;
		uniform float _Mask;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normals = i.uv_texcoord * _Normals_ST.xy + _Normals_ST.zw;
			float3 Normals59 = UnpackScaleNormal( tex2D( _Normals, uv_Normals ), _NormalsScale );
			o.Normal = Normals59;
			float2 uv_InsulationMask = i.uv_texcoord * _InsulationMask_ST.xy + _InsulationMask_ST.zw;
			float4 tex2DNode7 = tex2D( _InsulationMask, uv_InsulationMask );
			float MaskBlue70 = tex2DNode7.b;
			float2 uv4_TexCoord82 = i.uv4_texcoord4 + ( half2( 0.015625,0 ) * _ColorSelect );
			float4 ColorUV396 = tex2D( _MainTex, uv4_TexCoord82 );
			float2 appendResult88 = (float2((float)( _ColorSelect * 0 ) , -0.5));
			float2 uv4_TexCoord89 = i.uv4_texcoord4 + appendResult88;
			float4 DirtUV395 = tex2D( _MainTex, uv4_TexCoord89 );
			float3 temp_cast_1 = (( tex2DNode7.g * _DirtMultiplier )).xxx;
			float3 temp_cast_2 = (( 1.0 - i.vertexColor.r )).xxx;
			float DirtHeight14 = saturate( ( 1.0 - ( ( distance( temp_cast_1 , temp_cast_2 ) - _DirtRange ) / max( _DirtSmooth , 1E-05 ) ) ) );
			float4 lerpResult23 = lerp( ( MaskBlue70 * ( 1.0 - ( _InsulationDarkness * ( 1.0 - i.vertexColor.g ) ) ) * ColorUV396 ) , ( DirtUV395 * tex2DNode7.r ) , ( DirtHeight14 * _DirtOpacity ));
			float4 Albedo64 = lerpResult23;
			o.Albedo = ( Albedo64 * _Color ).rgb;
			o.Alpha = 1;
			float VertexGreen67 = i.vertexColor.g;
			clip( tex2DNode7.b - ( VertexGreen67 * _Mask ));
			float Opacity62 = 1.0;
			clip( Opacity62 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18935
2560;133;1920;1132;374.3759;503.2937;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;76;-2137.437,-1336.925;Inherit;False;1976.506;1065.818;Comment;12;96;95;94;90;89;88;87;86;82;81;78;106;UV3 Selection;1,1,1,1;0;0
Node;AmplifyShaderEditor.IntNode;78;-2065.438,-1065.777;Inherit;False;Property;_ColorSelect;ColorSelect;1;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-1762.314,-925.3151;Inherit;False;2;2;0;INT;0;False;1;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.DynamicAppendNode;88;-1580.932,-813.9043;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;106;-1375.463,-1075.801;Inherit;True;Property;_MainTex;Color Theme;0;0;Create;False;0;0;0;False;0;False;4e4a83f3dfdcd8445835fa14af43fa31;4e4a83f3dfdcd8445835fa14af43fa31;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;89;-1324.634,-828.4408;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;90;-916.3489,-958.1708;Inherit;True;Property;_TextureSample0;Texture Sample 0;12;0;Create;True;0;0;0;False;0;False;-1;None;4e4a83f3dfdcd8445835fa14af43fa31;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;5;-2271.365,1622.975;Inherit;False;2928.788;490.5811;Comment;11;37;14;13;9;11;10;7;8;67;70;12;Dirt;0.6037736,0.1110716,0.1110716,1;0;0
Node;AmplifyShaderEditor.Vector2Node;94;-2078.561,-1280.816;Half;False;Constant;_Vector1;Vector 1;19;0;Create;True;0;0;0;False;1;;False;0.015625,0;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-1644.385,-1271.225;Inherit;False;2;2;0;FLOAT2;0,0;False;1;INT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;7;-1937.101,1851.461;Inherit;True;Property;_InsulationMask;Insulation Mask;5;0;Create;True;0;0;0;False;0;False;-1;722ccb4026ebf614da8f4e012f433fa2;722ccb4026ebf614da8f4e012f433fa2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;37;-2206.417,1635.68;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-679.109,1954.241;Inherit;False;Property;_DirtMultiplier;Dirt Multiplier;9;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;-502.4198,-945.5846;Inherit;False;DirtUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;72;-2242.25,335.9264;Inherit;False;2099.698;1099.708;Comment;14;55;43;39;71;19;57;21;22;56;18;23;64;99;100;Color;0.661147,0.990566,0.2569865,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-210.6329,2048.291;Inherit;False;Property;_DirtSmooth;Dirt Smooth;8;0;Create;True;0;0;0;False;0;False;0;0.3944706;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-2061.155,1126.551;Inherit;False;95;DirtUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-370.1898,1849.294;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-206.52,1947.94;Inherit;False;Property;_DirtRange;Dirt Range;7;0;Create;True;0;0;0;False;0;False;0;0.1069264;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;9;-238.2679,1702.374;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;82;-1325.741,-1286.925;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.09,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;55;-1810.043,906.2452;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;86;-928.3269,-1155.554;Inherit;True;Property;_PrimaryColor;PrimaryColor;11;0;Create;True;0;0;0;False;0;False;-1;None;4e4a83f3dfdcd8445835fa14af43fa31;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1769.72,1198.047;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-2080.25,822.6673;Inherit;False;Property;_InsulationDarkness;Insulation Darkness;2;0;Create;True;0;0;0;False;0;False;0;0.196;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;13;92.40996,1680.969;Inherit;False;Color Mask;-1;;41;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.17;False;5;FLOAT;0.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-1503.131,1977.712;Inherit;False;MaskBlue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;-500.1374,-1138.112;Inherit;False;ColorUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;414.4212,1670.112;Inherit;False;DirtHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;73;-1355.35,1157.581;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1669.062,815.7724;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;74;-1276.645,632.7979;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1125.734,862.3249;Inherit;False;Property;_DirtOpacity;Dirt Opacity;6;0;Create;True;0;0;0;False;0;False;0;0.612;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-1767.626,385.9264;Inherit;False;70;MaskBlue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-1154.743,965.0944;Inherit;False;14;DirtHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;57;-1509.043,730.2451;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;67;-1957.168,1730.75;Inherit;False;VertexGreen;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-1945.957,667.3613;Inherit;False;96;ColorUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;69;-2286.958,2163.809;Inherit;False;1110.992;599.0815;Comment;5;68;34;36;62;102;Opacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-2178.691,2607.16;Inherit;False;Property;_Mask;Mask;11;0;Create;True;0;0;0;False;0;False;0;0.4;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-2152.958,2451.134;Inherit;False;67;VertexGreen;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;75;-1214.437,576.61;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-1396.043,505.2451;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-823.3435,913.2314;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;61;-2148.741,-108.3091;Inherit;False;923.9191;280;Comment;2;4;3;Normal;0.2142221,0.3497845,0.5471698,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1910.034,2462.908;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-2064.74,-2.317816;Inherit;False;Property;_NormalsScale;Normals Scale;4;0;Create;True;0;0;0;False;0;False;0;1.13;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;23;-730.4163,501.2708;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-369.1187,513.0587;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-1711.492,-85.0674;Inherit;True;Property;_Normals;Normals;3;0;Create;False;0;0;0;False;0;False;-1;1e6a95fe5438e044e80289142eedf514;1e6a95fe5438e044e80289142eedf514;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClipNode;36;-1597.736,2301.688;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-1389.951,-83.16348;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-1392.675,2333.071;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;595.5379,-102.5297;Inherit;False;64;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;108;550.1642,-302.1248;Inherit;False;Property;_Color;Color;12;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;796.0841,-117.4627;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;679.1057,247.6054;Inherit;False;62;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;675.6967,112.0614;Inherit;False;59;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;950.3867,-25.18216;Float;False;True;-1;4;;0;0;Standard;DBK/Insulation;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;10;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;87;0;78;0
WireConnection;88;0;87;0
WireConnection;89;1;88;0
WireConnection;90;0;106;0
WireConnection;90;1;89;0
WireConnection;81;0;94;0
WireConnection;81;1;78;0
WireConnection;95;0;90;0
WireConnection;10;0;7;2
WireConnection;10;1;8;0
WireConnection;9;0;37;1
WireConnection;82;1;81;0
WireConnection;55;0;37;2
WireConnection;86;0;106;0
WireConnection;86;1;82;0
WireConnection;18;0;100;0
WireConnection;18;1;7;1
WireConnection;13;1;9;0
WireConnection;13;3;10;0
WireConnection;13;4;11;0
WireConnection;13;5;12;0
WireConnection;70;0;7;3
WireConnection;96;0;86;0
WireConnection;14;0;13;0
WireConnection;73;0;18;0
WireConnection;39;0;43;0
WireConnection;39;1;55;0
WireConnection;74;0;73;0
WireConnection;57;0;39;0
WireConnection;67;0;37;2
WireConnection;75;0;74;0
WireConnection;56;0;71;0
WireConnection;56;1;57;0
WireConnection;56;2;99;0
WireConnection;22;0;19;0
WireConnection;22;1;21;0
WireConnection;34;0;68;0
WireConnection;34;1;102;0
WireConnection;23;0;56;0
WireConnection;23;1;75;0
WireConnection;23;2;22;0
WireConnection;64;0;23;0
WireConnection;3;5;4;0
WireConnection;36;1;7;3
WireConnection;36;2;34;0
WireConnection;59;0;3;0
WireConnection;62;0;36;0
WireConnection;107;0;65;0
WireConnection;107;1;108;0
WireConnection;0;0;107;0
WireConnection;0;1;60;0
WireConnection;0;10;63;0
ASEEND*/
//CHKSM=4B1C65AC5BAE4B899A48686F29EE865A7D09719A