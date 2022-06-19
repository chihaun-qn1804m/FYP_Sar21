// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DBK/GlassInterioir"
{
	Properties
	{
		_RoomIntensity("Room Intensity", Range( 0 , 0.25)) = 1
		[PerRendererData]_ColorSelect("ColorSelect", Int) = 0
		[NoScaleOffset]_MainTex("Glass Mask", 2D) = "black" {}
		_ColorTheme("Color Theme", 2D) = "white" {}
		_SmoothnessValue("Smoothness Value", Range( 0 , 1)) = 1
		[NoScaleOffset]_Floor("Floor", 2D) = "white" {}
		_FloorTexTiling("Floor Tex Tiling", Range( 0 , 10)) = 0
		[NoScaleOffset]_Wall("Wall", 2D) = "white" {}
		_WalltexTiling("Wall tex Tiling", Range( 0 , 2)) = 0
		[NoScaleOffset]_Back("Back", 2D) = "white" {}
		_BackWallTexTiling("Back Wall Tex Tiling", Range( 0 , 100)) = 0
		[NoScaleOffset]_Ceiling("Ceiling", 2D) = "white" {}
		_CeilingTexTiling("Ceiling Tex Tiling", Range( 0 , 100)) = 0
		_RoomTile("Room Tile", Range( 0.1 , 10)) = 0
		_RoomsXYZ("Rooms X Y Z", Vector) = (1,1,1,1)
		_PositionOffsetXYZ("Position Offset XYZ ", Vector) = (0,0,0,0)
		_GlassNM("Glass NM", 2D) = "bump" {}
		_Color("Color", Color) = (1,1,1,1)
		[Toggle(_SWITCHPLANE_ON)] _SwitchPlane("Switch Plane", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _SWITCHPLANE_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 vertexToFrag11;
		};

		uniform sampler2D _GlassNM;
		uniform float4 _GlassNM_ST;
		uniform float4 _RoomsXYZ;
		uniform float _RoomTile;
		uniform float4 _PositionOffsetXYZ;
		uniform sampler2D _Wall;
		uniform float _WalltexTiling;
		uniform sampler2D _Back;
		uniform float _BackWallTexTiling;
		uniform sampler2D _Floor;
		uniform float _FloorTexTiling;
		uniform sampler2D _Ceiling;
		uniform float _CeilingTexTiling;
		uniform float _RoomIntensity;
		uniform sampler2D _MainTex;
		uniform sampler2D _ColorTheme;
		uniform int _ColorSelect;
		uniform float4 _Color;
		uniform float _SmoothnessValue;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			o.vertexToFrag11 = ase_vertex3Pos;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_GlassNM = i.uv_texcoord * _GlassNM_ST.xy + _GlassNM_ST.zw;
			o.Normal = UnpackNormal( tex2D( _GlassNM, uv_GlassNM ) );
			float4 temp_output_31_0 = ( ( _RoomsXYZ + float4( -1E-05,-1E-05,-1E-05,-1E-05 ) ) * _RoomTile );
			#ifdef _SWITCHPLANE_ON
				float staticSwitch16 = (i.vertexToFrag11).z;
			#else
				float staticSwitch16 = (i.vertexToFrag11).x;
			#endif
			float4 appendResult20 = (float4(i.vertexToFrag11 , staticSwitch16));
			float4 InterpVertexPos24 = appendResult20;
			float4 temp_output_28_0 = ( InterpVertexPos24 - _PositionOffsetXYZ );
			float4 appendResult4 = (float4(_WorldSpaceCameraPos , 1.0));
			float4 temp_output_7_0 = mul( unity_WorldToObject, appendResult4 );
			#ifdef _SWITCHPLANE_ON
				float staticSwitch12 = (temp_output_7_0).z;
			#else
				float staticSwitch12 = (temp_output_7_0).x;
			#endif
			float4 appendResult18 = (float4((temp_output_7_0).xyz , staticSwitch12));
			float4 TransCameraPos21 = appendResult18;
			float4 V229 = ( TransCameraPos21 - _PositionOffsetXYZ );
			float4 V134 = ( temp_output_28_0 - V229 );
			float4 temp_output_42_0 = ( ( ( ( floor( ( temp_output_31_0 * temp_output_28_0 ) ) + step( float4( 0,0,0,0 ) , V134 ) ) / temp_output_31_0 ) - V229 ) / V134 );
			float Y85 = (temp_output_42_0).y;
			float newPlane46 = (temp_output_42_0).w;
			float Z66 = (temp_output_42_0).z;
			float temp_output_111_0 = step( newPlane46 , Z66 );
			float ifLocalVar121 = 0;
			if( temp_output_111_0 <= 0.0 )
				ifLocalVar121 = Z66;
			else
				ifLocalVar121 = newPlane46;
			float X84 = (temp_output_42_0).x;
			float temp_output_126_0 = step( ifLocalVar121 , X84 );
			float ifLocalVar130 = 0;
			if( temp_output_126_0 <= 0.0 )
				ifLocalVar130 = X84;
			else
				ifLocalVar130 = ifLocalVar121;
			float2 break99 = ( (( ( Z66 * V134 ) + V229 )).xy * _WalltexTiling );
			float2 appendResult105 = (float2(break99.x , break99.y));
			float4 WallVar120 = tex2D( _Wall, appendResult105 );
			float4 ifLocalVar128 = 0;
			if( temp_output_111_0 <= 0.0 )
				ifLocalVar128 = WallVar120;
			float4 BackVar129 = tex2D( _Back, ( (( ( X84 * V134 ) + V229 )).zy * _BackWallTexTiling ) );
			float4 ifLocalVar134 = 0;
			if( temp_output_126_0 <= 0.0 )
				ifLocalVar134 = BackVar129;
			else
				ifLocalVar134 = ifLocalVar128;
			float2 temp_output_108_0 = (( ( Y85 * V134 ) + V229 )).xz;
			float Y_inverted114 = (V134).y;
			float4 lerpResult127 = lerp( tex2D( _Floor, ( temp_output_108_0 * _FloorTexTiling ) ) , tex2D( _Ceiling, ( temp_output_108_0 * _CeilingTexTiling ) ) , step( 0.0 , Y_inverted114 ));
			float4 CeilVar131 = lerpResult127;
			float4 ifLocalVar140 = 0;
			if( Y85 <= ifLocalVar130 )
				ifLocalVar140 = CeilVar131;
			else
				ifLocalVar140 = ifLocalVar134;
			float2 uv_MainTex149 = i.uv_texcoord;
			float4 tex2DNode149 = tex2D( _MainTex, uv_MainTex149 );
			float2 uv_TexCoord164 = i.uv_texcoord * half2( 0,-0.1 ) + ( half2( 0.015625,0 ) * _ColorSelect );
			float4 lerpResult152 = lerp( ( ifLocalVar140 * _RoomIntensity ) , ( tex2DNode149.r * tex2D( _ColorTheme, uv_TexCoord164 ) ) , tex2DNode149.g);
			o.Albedo = ( lerpResult152 * _Color ).rgb;
			o.Smoothness = ( tex2DNode149.r * _SmoothnessValue );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18935
2560;133;1920;1132;-4649.409;2758.393;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;1;-1334.84,640.6821;Inherit;False;1682.485;471.1538;Comment;11;21;18;13;12;10;9;7;6;4;3;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;2;-1288.74,798.6716;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;3;-1190.141,955.7729;Float;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;5;-1333.67,240.6294;Inherit;False;1411.799;332.554;Comment;7;24;20;16;15;14;11;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldToObjectMatrix;6;-1044.843,745.5743;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.DynamicAppendNode;4;-980.8427,873.5712;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-773.3126,716.3962;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PosVertexDataNode;8;-1283.67,290.6284;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexToFragmentNode;11;-1049.815,316.8224;Inherit;False;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;9;-581.3122,812.3948;Inherit;False;False;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;10;-581.3122,908.3942;Inherit;False;True;False;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;13;-581.3122,716.3962;Inherit;False;True;True;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;14;-803.2615,395.9094;Inherit;False;False;False;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;12;-341.3117,844.3939;Float;False;Property;_SwitchPlane;Switch Plane;9;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;15;-803.2615,475.9094;Inherit;False;True;False;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-117.3113,716.3962;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StaticSwitch;16;-563.261,427.9094;Float;False;Property;_SwitchPlane;Switch Plane;19;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;90.68875,716.3962;Float;False;TransCameraPos;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-355.2606,315.9094;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;17;-1345.578,1196.622;Inherit;False;2944.635;705.8434;Comment;32;114;102;98;85;84;72;71;66;60;46;43;42;41;40;39;38;37;36;35;34;33;32;31;30;29;28;27;26;25;23;22;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-147.2603,331.9094;Float;False;InterpVertexPos;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector4Node;22;-1280.501,1595.696;Float;False;Property;_PositionOffsetXYZ;Position Offset XYZ ;16;0;Create;True;0;0;0;False;0;False;0,0,0,0;3.35,-0.37,1.5,-4.2;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;19;-1153.501,1786.696;Inherit;False;21;TransCameraPos;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-1137.501,1466.696;Inherit;False;24;InterpVertexPos;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector4Node;25;-1249.501,1258.696;Float;False;Property;_RoomsXYZ;Rooms X Y Z;15;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.55,1.02,0.78,0.41;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-801.5018,1674.696;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-593.502,1626.696;Float;False;V2;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;28;-801.5018,1466.696;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-945.5018,1370.696;Float;False;Property;_RoomTile;Room Tile;14;0;Create;True;0;0;0;False;0;False;0;0.3;0.1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-865.5018,1258.696;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;-1E-05,-1E-05,-1E-05,-1E-05;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-609.502,1258.696;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;-321.5017,1546.696;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-145.5012,1546.696;Float;False;V1;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-385.5018,1370.696;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FloorOpNode;36;-97.50125,1370.696;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StepOpNode;35;78.49879,1466.696;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;222.4986,1370.696;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;366.4986,1402.696;Inherit;False;29;V2;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;39;366.4986,1242.696;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;40;574.4982,1242.696;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;606.4983,1402.696;Inherit;False;34;V1;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;42;785.0413,1244.956;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;60;1070.499,1466.696;Inherit;False;False;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;1310.499,1466.696;Float;False;Z;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;59;-1360.073,-278.8632;Inherit;False;2337.914;375.4672;;12;120;109;105;99;92;80;79;74;68;67;64;63;Walls;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-1335.662,-75.64319;Inherit;False;34;V1;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-1331.929,-194.2272;Inherit;False;66;Z;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;72;1070.499,1354.696;Inherit;False;False;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-1053.974,-207.4633;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;71;1070.499,1258.696;Inherit;False;True;False;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-1080.157,-81.24219;Inherit;False;29;V2;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;1310.499,1354.696;Float;False;Y;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-835.9735,-171.6632;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;73;-1341.313,-1800.731;Inherit;False;1975.845;668.0294;;16;131;127;123;118;116;115;113;110;108;106;103;95;90;89;86;83;Floor Ceiling;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;1310.499,1258.696;Float;False;X;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;75;-1359.842,-955.6019;Inherit;False;1809.348;420.048;;10;129;122;112;104;101;94;93;88;78;77;Back Wall;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-736.9547,-15.49121;Float;False;Property;_WalltexTiling;Wall tex Tiling;8;0;Create;True;0;0;0;False;0;False;0;0.3;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-1325.313,-776.7312;Inherit;False;34;V1;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;80;-664.8729,-185.2642;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-1309.313,-1640.731;Inherit;False;34;V1;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-1309.313,-1736.731;Inherit;False;85;Y;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;-1325.313,-888.7312;Inherit;False;84;X;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;830.4983,1690.696;Inherit;False;34;V1;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;-1037.313,-1624.731;Inherit;False;29;V2;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;88;-1063.261,-763.185;Inherit;False;29;V2;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-1030.741,-898.4028;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-1037.313,-1736.731;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-418.1728,-122.3643;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;102;1065.973,1692.758;Inherit;False;False;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;94;-829.3125,-888.7312;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;99;-251.6591,-141.2062;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-829.3125,-1736.731;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;43;1070.499,1578.696;Inherit;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-761.6124,-666.0585;Float;False;Property;_BackWallTexTiling;Back Wall Tex Tiling;11;0;Create;True;0;0;0;False;0;False;0;0.3;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;104;-655.7943,-890.4462;Inherit;False;FLOAT2;2;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;1310.499,1578.696;Float;False;newPlane;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;1310.499,1690.696;Float;False;Y_inverted;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-717.3125,-1432.731;Float;False;Property;_CeilingTexTiling;Ceiling Tex Tiling;13;0;Create;True;0;0;0;False;0;False;0;0.15;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;108;-637.3125,-1736.731;Inherit;False;True;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-717.3125,-1608.731;Float;False;Property;_FloorTexTiling;Floor Tex Tiling;6;0;Create;True;0;0;0;False;0;False;0;0.15;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;105;51.23314,-147.0889;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;82;1371.498,-1825.64;Inherit;False;1936.548;573.6697;;14;140;136;134;133;130;128;126;124;121;119;117;111;100;97;Mix;0,0.7426471,0.6100315,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;1430.046,-1647.64;Inherit;False;66;Z;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;109;205.0908,-237.8016;Inherit;True;Property;_Wall;Wall;7;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;254607d38a149b34686722576dbdcc96;254607d38a149b34686722576dbdcc96;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-472.5395,-798.0016;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-205.3125,-1272.731;Inherit;False;114;Y_inverted;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;1430.046,-1743.64;Inherit;False;46;newPlane;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-349.3125,-1736.731;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-349.3125,-1544.731;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;631.3807,-224.9034;Float;False;WallVar;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;122;-167.1613,-849.3633;Inherit;True;Property;_Back;Back;10;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;254607d38a149b34686722576dbdcc96;254607d38a149b34686722576dbdcc96;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;116;-141.3125,-1720.731;Inherit;True;Property;_Floor;Floor;5;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;f361abd048ecd7946beef104952d0cb8;f361abd048ecd7946beef104952d0cb8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;111;2022.046,-1599.64;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;118;-155.6125,-1496.731;Inherit;True;Property;_Ceiling;Ceiling;12;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;aec6a9728174f4345a2499e67f3d199b;aec6a9728174f4345a2499e67f3d199b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;158;2490.247,-3369.975;Inherit;False;2080.08;813.5428;Comment;7;165;164;163;162;161;160;159;Color Selection;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;123;34.68753,-1289.731;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;160;2696.556,-2989.806;Inherit;False;Property;_ColorSelect;ColorSelect;1;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;1;False;0;1;INT;0
Node;AmplifyShaderEditor.Vector2Node;159;2622.039,-3275.837;Half;False;Constant;_NumberOfColors;NumberOfColors;19;0;Create;True;0;0;0;False;1;;False;0.015625,0;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;234.2426,-862.8408;Float;False;BackVar;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;121;2182.046,-1775.64;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;1894.046,-1343.64;Inherit;False;120;WallVar;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;127;210.6875,-1624.731;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;2182.046,-1583.64;Inherit;False;84;X;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;2945.336,-3156.644;Inherit;False;2;2;0;FLOAT2;0,0;False;1;INT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ConditionalIfNode;128;2226.841,-1437.694;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT4;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;131;402.6875,-1608.731;Float;False;CeilVar;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;2422.046,-1359.64;Inherit;False;129;BackVar;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;161;2996.034,-3348.956;Half;False;Constant;_ColorsNumber;ColorsNumber;19;0;Create;True;0;0;0;False;1;;False;0,-0.1;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StepOpNode;126;2470.046,-1535.64;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;163;3429.195,-3150.455;Inherit;True;Property;_ColorTheme;Color Theme;3;0;Create;True;0;0;0;False;0;False;cd4b5d8aeef219c4bafd11ce2d4d5525;cd4b5d8aeef219c4bafd11ce2d4d5525;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;164;3429.926,-3296.857;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;136;2694.046,-1583.64;Inherit;False;85;Y;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;130;2694.046,-1775.64;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;2886.046,-1375.64;Inherit;False;131;CeilVar;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;134;2694.046,-1455.64;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;138;3346.549,-1495.357;Float;False;Property;_RoomIntensity;Room Intensity;0;0;Create;True;0;0;0;False;0;False;1;0.057;0;0.25;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;149;3387.302,-2226.936;Inherit;True;Property;_MainTex;Glass Mask;2;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;bfbde71c1a80a6f448fd18fc39306db8;bfbde71c1a80a6f448fd18fc39306db8;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;140;3126.046,-1583.64;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;165;3855.037,-3296.752;Inherit;True;Property;_TextureSample2;Texture Sample 2;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;4218.676,-2280.648;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;3683.335,-1583.048;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;148;4471.439,-1815.384;Float;False;Property;_SmoothnessValue;Smoothness Value;4;0;Create;True;0;0;0;False;0;False;1;0.796;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;152;4507.233,-2223.043;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;169;5168.167,-2410.993;Inherit;False;Property;_Color;Color;18;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;157;4896.193,-2140.321;Inherit;True;Property;_GlassNM;Glass NM;17;0;Create;True;0;0;0;False;0;False;-1;9297249ecc862d24d9d18b58ff475d1d;9297249ecc862d24d9d18b58ff475d1d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;168;5383.087,-2266.331;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;4813.54,-1861.929;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5630.107,-2237.373;Float;False;True;-1;2;;0;0;Standard;DBK/GlassInterioir;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;2;0
WireConnection;4;3;3;0
WireConnection;7;0;6;0
WireConnection;7;1;4;0
WireConnection;11;0;8;0
WireConnection;9;0;7;0
WireConnection;10;0;7;0
WireConnection;13;0;7;0
WireConnection;14;0;11;0
WireConnection;12;1;10;0
WireConnection;12;0;9;0
WireConnection;15;0;11;0
WireConnection;18;0;13;0
WireConnection;18;3;12;0
WireConnection;16;1;15;0
WireConnection;16;0;14;0
WireConnection;21;0;18;0
WireConnection;20;0;11;0
WireConnection;20;3;16;0
WireConnection;24;0;20;0
WireConnection;23;0;19;0
WireConnection;23;1;22;0
WireConnection;29;0;23;0
WireConnection;28;0;26;0
WireConnection;28;1;22;0
WireConnection;30;0;25;0
WireConnection;31;0;30;0
WireConnection;31;1;27;0
WireConnection;32;0;28;0
WireConnection;32;1;29;0
WireConnection;34;0;32;0
WireConnection;33;0;31;0
WireConnection;33;1;28;0
WireConnection;36;0;33;0
WireConnection;35;1;34;0
WireConnection;37;0;36;0
WireConnection;37;1;35;0
WireConnection;39;0;37;0
WireConnection;39;1;31;0
WireConnection;40;0;39;0
WireConnection;40;1;38;0
WireConnection;42;0;40;0
WireConnection;42;1;41;0
WireConnection;60;0;42;0
WireConnection;66;0;60;0
WireConnection;72;0;42;0
WireConnection;68;0;63;0
WireConnection;68;1;64;0
WireConnection;71;0;42;0
WireConnection;85;0;72;0
WireConnection;74;0;68;0
WireConnection;74;1;67;0
WireConnection;84;0;71;0
WireConnection;80;0;74;0
WireConnection;93;0;77;0
WireConnection;93;1;78;0
WireConnection;90;0;86;0
WireConnection;90;1;83;0
WireConnection;92;0;80;0
WireConnection;92;1;79;0
WireConnection;102;0;98;0
WireConnection;94;0;93;0
WireConnection;94;1;88;0
WireConnection;99;0;92;0
WireConnection;95;0;90;0
WireConnection;95;1;89;0
WireConnection;43;0;42;0
WireConnection;104;0;94;0
WireConnection;46;0;43;0
WireConnection;114;0;102;0
WireConnection;108;0;95;0
WireConnection;105;0;99;0
WireConnection;105;1;99;1
WireConnection;109;1;105;0
WireConnection;112;0;104;0
WireConnection;112;1;101;0
WireConnection;113;0;108;0
WireConnection;113;1;103;0
WireConnection;110;0;108;0
WireConnection;110;1;106;0
WireConnection;120;0;109;0
WireConnection;122;1;112;0
WireConnection;116;1;113;0
WireConnection;111;0;100;0
WireConnection;111;1;97;0
WireConnection;118;1;110;0
WireConnection;123;1;115;0
WireConnection;129;0;122;0
WireConnection;121;0;111;0
WireConnection;121;2;100;0
WireConnection;121;3;97;0
WireConnection;121;4;97;0
WireConnection;127;0;116;0
WireConnection;127;1;118;0
WireConnection;127;2;123;0
WireConnection;162;0;159;0
WireConnection;162;1;160;0
WireConnection;128;0;111;0
WireConnection;128;3;119;0
WireConnection;128;4;119;0
WireConnection;131;0;127;0
WireConnection;126;0;121;0
WireConnection;126;1;117;0
WireConnection;164;0;161;0
WireConnection;164;1;162;0
WireConnection;130;0;126;0
WireConnection;130;2;121;0
WireConnection;130;3;117;0
WireConnection;130;4;117;0
WireConnection;134;0;126;0
WireConnection;134;2;128;0
WireConnection;134;3;124;0
WireConnection;134;4;124;0
WireConnection;140;0;136;0
WireConnection;140;1;130;0
WireConnection;140;2;134;0
WireConnection;140;3;133;0
WireConnection;140;4;133;0
WireConnection;165;0;163;0
WireConnection;165;1;164;0
WireConnection;167;0;149;1
WireConnection;167;1;165;0
WireConnection;144;0;140;0
WireConnection;144;1;138;0
WireConnection;152;0;144;0
WireConnection;152;1;167;0
WireConnection;152;2;149;2
WireConnection;168;0;152;0
WireConnection;168;1;169;0
WireConnection;151;0;149;1
WireConnection;151;1;148;0
WireConnection;0;0;168;0
WireConnection;0;1;157;0
WireConnection;0;4;151;0
ASEEND*/
//CHKSM=5A0CD1619FE7226D883E7BA71049EE9C55275862