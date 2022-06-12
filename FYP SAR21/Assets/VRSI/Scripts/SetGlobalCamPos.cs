using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetGlobalCamPos : MonoBehaviour
{
    public Transform camTrans;
    
    void Update()
    {
        Shader.SetGlobalVector("_MainCamWorldPos",new Vector4(camTrans.position.x, camTrans.position.y, camTrans.position.z,0));
    }
}
