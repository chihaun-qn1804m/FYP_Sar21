using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(VRSI_RenderTool_MultiView))]
public class VRSI_RenderTool_MultiView_Editor : Editor
{
    private VRSI_RenderTool_MultiView myTarget;
    private Texture logoTex;
    
    GUIStyle backcol1 = new GUIStyle();
    GUIStyle backcol2 = new GUIStyle();

    private Texture2D MakeTex(int width, int height, Color col)
    {
        Color[] pix = new Color[width * height];

        for (int i = 0; i < pix.Length; i++)
            pix[i] = col;

        Texture2D result = new Texture2D(width, height);
        result.SetPixels(pix);
        result.Apply();

        return result;
    }

    public static void DrawUILine(Color color, int thickness = 2, int padding = 10)
    {
        Rect r = EditorGUILayout.GetControlRect(GUILayout.Height(padding + thickness));
        r.height = thickness;
        r.y += padding / 2;
        r.x -= 2;
        r.width += 6;
        EditorGUI.DrawRect(r, color);
    }

    public override void OnInspectorGUI() {

        EditorGUI.BeginChangeCheck();

        Color tmpbgcol = GUI.backgroundColor;
        Color tmpGuiCol = GUI.color;
        Color tmpContentCol = GUI.contentColor;

        if (logoTex != null)
        {
            float w = EditorGUIUtility.currentViewWidth;
            
            GUI.backgroundColor = Color.black;
            GUILayout.BeginHorizontal(backcol1);
            GUILayout.FlexibleSpace();
            GUILayout.Box(logoTex, GUILayout.Width(w),  GUILayout.Height(w/2) , GUILayout.MinWidth(300), GUILayout.MinHeight(150));
            GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal();
            GUI.backgroundColor = tmpbgcol;
        }

       

        if (!myTarget.getInVRMode())
        {
            GUILayout.BeginVertical(backcol2);
            int tmpfs = GUI.skin.label.fontSize;
            Color tmptxtcol = GUI.skin.label.normal.textColor;

            GUI.backgroundColor = Color.white;
            GUI.skin.label.normal.textColor = new Color(0.95f, 0.6f, 0);
            GUI.skin.label.fontSize = 22;
            GUILayout.Label("Step 1", GUILayout.Width(300), GUILayout.Height(30));

            GUI.skin.label.fontSize = 15;
            GUI.skin.label.normal.textColor = Color.white;            
            GUIStyle boxStyle = new GUIStyle(GUI.skin.box);
            boxStyle.normal.textColor = new Color(0.3f, 0.8f, 0.8f);
            boxStyle.alignment = TextAnchor.MiddleCenter;
            GUI.backgroundColor = new Color(0.1f, 0.5f, 0.9f);
            GUILayout.Box("Place The GameObject/s At The Center Of TurnTable And Make Them A Child Of OBJECTS_TO_RENDER", boxStyle, GUILayout.ExpandWidth(true));
            GUI.backgroundColor = tmpbgcol;            

            GUI.skin.label.fontSize = tmpfs;
            GUI.skin.label.normal.textColor = tmptxtcol;

            //====================
            //Step 2
            //====================
            GUI.skin.label.normal.textColor = new Color(0.95f, 0.6f, 0);
            GUI.skin.label.fontSize = 22;
            GUILayout.Label("Step 2");

            GUI.skin.label.fontSize = 13;
            GUI.skin.label.normal.textColor = Color.white;

            GUI.backgroundColor = new Color(0.1f, 0.5f, 0.9f);
            GUILayout.Box("Adjust The Parameters Below To Fit Objects Within Cameras Field Of View", boxStyle, GUILayout.ExpandWidth(true));
            GUI.backgroundColor = tmpbgcol;

            GUI.skin.label.fontSize = tmpfs;
            GUI.skin.label.normal.textColor = tmptxtcol;
            
            GUILayout.Space(10);            

            GUI.skin.label.normal.textColor = Color.white;

            GUIStyle myToggleStyle = new GUIStyle(GUI.skin.toggle);
            Color tmptoggleCol = myToggleStyle.normal.textColor;

            myToggleStyle.normal.textColor = Color.white;

            
            myTarget.focalPlaneVisible = GUILayout.Toggle(myTarget.focalPlaneVisible, "Show Focal Plane", myToggleStyle);

            GUILayout.Space(5);

            //Focal Point Z Value
            GUILayout.BeginHorizontal();
            GUILayout.Label(new GUIContent("FocalPlane Z-Offset", "Set this value so just where the object touches the ground lies behind the FocalPlane"), GUILayout.Width(150));
            myTarget.focalPointZvalue = EditorGUILayout.Slider(myTarget.focalPointZvalue, -3.0f, 3.0f);
            GUILayout.EndHorizontal();

            GUILayout.Space(10);

            //Focal Point Height
            GUILayout.BeginHorizontal();
            GUILayout.Label(new GUIContent("FocalPoint Height", "Vertical height (Y-value) of the Focal Point"), GUILayout.Width(150));
            myTarget.focalPointHeight = EditorGUILayout.Slider(myTarget.focalPointHeight, 0.0f, 5.0f);
            GUILayout.EndHorizontal();

            GUILayout.Space(5);

            //Observer Point Height
            GUILayout.BeginHorizontal();
            GUILayout.Label("Observer Height", GUILayout.Width(150));
            myTarget.ObserverHeight = EditorGUILayout.Slider(myTarget.ObserverHeight, 0.0f, 5.0f);
            GUILayout.EndHorizontal();

            GUILayout.Space(5);            

            //Observer Distance
            GUILayout.BeginHorizontal();
            GUILayout.Label("Observer Distance", GUILayout.Width(150));
            myTarget.ObserverDistance = EditorGUILayout.Slider(myTarget.ObserverDistance, 0.0f, 20.0f);
            GUILayout.EndHorizontal();            
            
            GUILayout.Space(5); 

            //====================
            //Step 3
            //====================

            GUI.skin.label.normal.textColor = new Color(0.95f, 0.6f, 0);
            GUI.skin.label.fontSize = 22;
            GUILayout.Label("Step 3");

            GUI.skin.label.fontSize = 13;
            GUI.skin.label.normal.textColor = Color.white;


            GUI.backgroundColor = new Color(0.1f, 0.5f, 0.9f);
            GUILayout.Box("VRSI Creation Parameters", boxStyle, GUILayout.ExpandWidth(true));
            GUI.backgroundColor = tmpbgcol;
            
            GUILayout.Space(10);
            //----------------------------------------------------------
            //Advanced Settings
            //----------------------------------------------------------
            //if(GUILayout.Button("+Show Advanced Settings"))
            //{
            //}
            //Eye Seperation
            GUILayout.BeginHorizontal();
            GUILayout.Label("Eye Seperation", GUILayout.Width(150));
            myTarget.seperation = EditorGUILayout.Slider(myTarget.seperation, 0.0f, 0.15f);
            GUILayout.EndHorizontal();


            GUILayout.Space(5);

            //Seperation Falloff Curve
            GUILayout.BeginHorizontal();
            GUILayout.Label("Seperation Fall-Off", GUILayout.Width(150));
            GUILayout.FlexibleSpace();
            myTarget.seperationCurve = EditorGUILayout.CurveField("", myTarget.seperationCurve);

            GUI.backgroundColor = tmpbgcol;

            GUILayout.EndHorizontal();
            //----------------------------------------------------------

            GUILayout.Space(15);

            //Resolution Select        
            GUILayout.BeginHorizontal();
            GUILayout.Label("VRSI Resolution", GUILayout.Width(150));
            GUILayout.FlexibleSpace();
            myTarget.vrsiResolution = (VRSI_RenderTool_MultiView.VRSI_Resolution)EditorGUILayout.EnumPopup("", myTarget.vrsiResolution, GUILayout.Width(150));
            GUILayout.EndHorizontal();

            if (myTarget.vrsiResolution == VRSI_RenderTool_MultiView.VRSI_Resolution.VeryLow_256)
            {
                myTarget.vrsiRenderSize = 128;
            }
            else if (myTarget.vrsiResolution == VRSI_RenderTool_MultiView.VRSI_Resolution.Low_512)
            {
                myTarget.vrsiRenderSize = 256;
            }
            else if (myTarget.vrsiResolution == VRSI_RenderTool_MultiView.VRSI_Resolution.Medium_1024)
            {
                myTarget.vrsiRenderSize = 512;
            }
            else if (myTarget.vrsiResolution == VRSI_RenderTool_MultiView.VRSI_Resolution.High_2048)
            {
                myTarget.vrsiRenderSize = 1024;
            }
            else if (myTarget.vrsiResolution == VRSI_RenderTool_MultiView.VRSI_Resolution.VeryHigh_4096)
            {
                myTarget.vrsiRenderSize = 2048;
            }

            GUILayout.Space(5);

            //Resolution Select  For Normal Map      
            GUILayout.BeginHorizontal();
            GUILayout.Label("Normalmap Resolution", GUILayout.Width(150));
            GUILayout.FlexibleSpace();
            myTarget.vrsiResolutionNormal = (VRSI_RenderTool_MultiView.VRSI_Resolution)EditorGUILayout.EnumPopup("", myTarget.vrsiResolutionNormal, GUILayout.Width(150));
            GUILayout.EndHorizontal();

            if (myTarget.vrsiResolutionNormal == VRSI_RenderTool_MultiView.VRSI_Resolution.VeryLow_256)
            {
                myTarget.vrsiRenderSizeNormal = 256;
            }
            else if (myTarget.vrsiResolutionNormal == VRSI_RenderTool_MultiView.VRSI_Resolution.Low_512)
            {
                myTarget.vrsiRenderSizeNormal = 512;
            }
            else if (myTarget.vrsiResolutionNormal == VRSI_RenderTool_MultiView.VRSI_Resolution.Medium_1024)
            {
                myTarget.vrsiRenderSizeNormal = 1024;
            }
            else if (myTarget.vrsiResolutionNormal == VRSI_RenderTool_MultiView.VRSI_Resolution.High_2048)
            {
                myTarget.vrsiRenderSizeNormal = 2048;
            }
            else if (myTarget.vrsiResolutionNormal == VRSI_RenderTool_MultiView.VRSI_Resolution.VeryHigh_4096)
            {
                myTarget.vrsiRenderSizeNormal = 4096;
            }

            GUILayout.Space(15);

            //Folder Name
            GUILayout.BeginHorizontal();
            GUILayout.Label("Folder Name");
            myTarget.folderName = GUILayout.TextField(myTarget.folderName, 40);
            GUILayout.EndHorizontal();

            GUILayout.Space(5);

            //vrsiName
            GUILayout.BeginHorizontal();
            GUILayout.Label("VRSI Name");
            myTarget.vrsiName = GUILayout.TextField(myTarget.vrsiName, 60);
            GUILayout.EndHorizontal();

            GUILayout.Space(5);

            GUI.skin.label.fontSize = tmpfs;
            GUI.skin.label.normal.textColor = tmptxtcol;

           
            GUILayout.Space(10);
            GUI.backgroundColor = Color.white;
            GUI.skin.label.normal.textColor = new Color(0.95f, 0.6f, 0);
            GUI.skin.label.fontSize = 12;            

            myTarget.AlphaToCoverage = GUILayout.Toggle(myTarget.AlphaToCoverage, "Enable AlphaToCoverage(MSAA Support)", myToggleStyle);

            GUILayout.Space(20);
            DrawUILine(new Color(0.05f, 0.6f, 0.95f, 0.25f), 2, 3);
            GUILayout.Space(5);
            //myTarget.AllowPostProcess = GUILayout.Toggle(myTarget.AllowPostProcess, "Allow Asset Re-Import", myToggleStyle);            

            GUI.backgroundColor = new Color(0.1f, 0.5f, 0.9f);
            GUILayout.Box("Multi-View Render Settings", boxStyle, GUILayout.ExpandWidth(true));
            

            //GUI.contentColor = new Color(0.6f, 0.6f, 0.6f);
            //GUI.backgroundColor = new Color(0.6f, 0.6f, 0.6f);
            GUILayout.Label("Keep The View Count To Minimum");
            //GUI.color = tmpGuiCol;
            //GUI.backgroundColor = tmpbgcol;
            myTarget.MultiViewPointCount = EditorGUILayout.IntField("Multi-View Count:", myTarget.MultiViewPointCount);

            //GUILayout.Space(5);           

            GUI.backgroundColor = Color.white;
            GUI.skin.label.normal.textColor = new Color(0.95f, 0.6f, 0);
            GUI.skin.label.fontSize = 14;           

            GUILayout.Space(5);
            DrawUILine(new Color(0.05f, 0.6f, 0.95f, 0.25f), 2, 3);
            GUILayout.Space(10);


            //Restore
            GUI.skin.label.normal.textColor = tmptxtcol;

            GUILayout.EndVertical();            

            myToggleStyle.normal.textColor = tmptoggleCol;

            
        }

        GUILayout.BeginHorizontal(backcol2);
           // GUILayout.Space(100);
            GUILayout.FlexibleSpace();


            if (Application.isPlaying)
            {
                if (!myTarget.getInVRMode())
                {
                    GUI.color = Color.cyan;
                    if (GUILayout.Button("CREATE VRSI", GUILayout.MaxWidth(148)))
                    {

                        myTarget.CreateVRSI();

                    }
                }

                GUI.color = Color.green;

                if (!myTarget.getInVRMode())
                {
                    if (GUILayout.Button("START VR PREVIEW", GUILayout.MaxWidth(148)))
                    {

                        myTarget.enableVRpreview();

                    }
                }
                else
                {
                    if (GUILayout.Button("STOP VR PREVIEW", GUILayout.MaxWidth(148)))
                    {

                        myTarget.stopVRpreview();
                        Repaint();

                    }
                }

            }
            else
            {
                GUILayout.Box("   Press Play To Enable VRSI Generator   ", GUILayout.ExpandWidth(true));
            
            }     

            GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal(); 

            GUI.color = tmpGuiCol;
            GUI.backgroundColor = tmpbgcol;
            GUI.contentColor = tmpContentCol;
        

        if (EditorGUI.EndChangeCheck())
        {
            if(myTarget.focalPlaneVisible)
            {
                if (myTarget.refDebugFocalPlane != null)
                {
                    myTarget.refDebugFocalPlane.GetComponent<MeshRenderer>().enabled = true;
                }
            }
            else
            {
                if (myTarget.refDebugFocalPlane != null)
                {
                    myTarget.refDebugFocalPlane.GetComponent<MeshRenderer>().enabled = false;
                }
            }
            //Mark As Dirty
            EditorUtility.SetDirty(myTarget);
        }

    }

    private float m_LastEditorUpdateTime;


    protected virtual void Awake()
    {

        myTarget = (VRSI_RenderTool_MultiView)target;

        logoTex = Resources.Load<Texture>("Textures/VRSI_Multi_View");

        backcol1.normal.background = MakeTex(1, 1, new Color(0, 0, 0, 1));
        
    }

    protected virtual void OnEnable()
    {
        myTarget = (VRSI_RenderTool_MultiView)target;

#if UNITY_EDITOR
		m_LastEditorUpdateTime = Time.realtimeSinceStartup;
		EditorApplication.update += OnEditorUpdate;
#endif
        backcol2.normal.background = MakeTex(1, 1, new Color(0.0f, 0.2f, 0.2f, 1));
    }

    protected virtual void OnDisable()
    {
#if UNITY_EDITOR
		EditorApplication.update -= OnEditorUpdate;
#endif
    }

    protected virtual void OnEditorUpdate()
    {
        float timesinceStart = (Time.realtimeSinceStartup - m_LastEditorUpdateTime);

        if (timesinceStart > 0.01f)
        {

            myTarget.Tick();

            m_LastEditorUpdateTime = Time.realtimeSinceStartup;
        }

    }

}