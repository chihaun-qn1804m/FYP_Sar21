using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class CullFix : MonoBehaviour
{
    void Start()
    {        
        float boundwidth = 40.0f;
        GetComponent<MeshFilter>().mesh.bounds = new UnityEngine.Bounds(new Vector3(0, 0, 0), new Vector3(1, 1, 1) * boundwidth);
    }
    
}
