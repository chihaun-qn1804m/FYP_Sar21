using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VRFootIK : MonoBehaviour
{
    private Animator animator;
    public Vector3 footOffSet;
    [Range(0,1)]
    public float rightFootPosWeight = 1;
    [Range(0,1)]
    public float rightFootRotWeight = 1;
    [Range(0,1)]
    public float leftFootPosWeight = 1;
    [Range(0,1)]
    public float leftFootRotWeight = 1;

    // Start is called before the first frame update
    void Start()
    {
        //access to the animator component being called from above
        animator = GetComponent<Animator>();
    }

    private void OnAnimatorIK(int layerIndex)
    {
        //set the position of the right foot
        Vector3 rightFootPos = animator.GetIKPosition(AvatarIKGoal.RightFoot);
        //set the ground position 
        RaycastHit hit;

        //check if avatar has hit the ground using bool
        bool hasHit = Physics.Raycast(rightFootPos + Vector3.up, Vector3.down, out hit);
        if(hasHit)
        {
            animator.SetIKPositionWeight(AvatarIKGoal.RightFoot,rightFootPosWeight);
            animator.SetIKPosition(AvatarIKGoal.RightFoot, hit.point + footOffSet);

            //create a rotation that acts as a forward axis 
            Quaternion rightFootRotation = Quaternion.LookRotation(Vector3.ProjectOnPlane(transform.forward, hit.normal), hit.normal);
            animator.SetIKRotationWeight(AvatarIKGoal.RightFoot, rightFootRotWeight);
            animator.SetIKRotation(AvatarIKGoal.RightFoot, rightFootRotation);

        } else
        {
            //if ground cannot be found then set the weight to zero 
            animator.SetIKPositionWeight(AvatarIKGoal.RightFoot, 0);
        }

         //set the position of the left foot
        Vector3 leftFootPos = animator.GetIKPosition(AvatarIKGoal.LeftFoot);

        //check if avatar has hit the ground
        hasHit = Physics.Raycast(leftFootPos + Vector3.up, Vector3.down, out hit);
        if(hasHit)
        {
            animator.SetIKPositionWeight(AvatarIKGoal.LeftFoot,leftFootPosWeight);
            animator.SetIKPosition(AvatarIKGoal.LeftFoot, hit.point + footOffSet);

            //create a rotation that acts as a forward axis 
            Quaternion leftFootRotation = Quaternion.LookRotation(Vector3.ProjectOnPlane(transform.forward, hit.normal), hit.normal);
            animator.SetIKRotationWeight(AvatarIKGoal.LeftFoot, leftFootRotWeight);
            animator.SetIKRotation(AvatarIKGoal.LeftFoot, leftFootRotation);
            
        } else
        {
            //if ground cannot be found then set the weight to zero 
            animator.SetIKPositionWeight(AvatarIKGoal.LeftFoot, 0);

        }
    }
}