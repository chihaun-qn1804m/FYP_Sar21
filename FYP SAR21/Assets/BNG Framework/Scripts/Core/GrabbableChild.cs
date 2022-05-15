using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace BNG
{
    public class GrabbableChild : GrabbableEvents
    {

        public Grabbable ParentGrabbable;

        public override void OnGrab(Grabber grabber)
        {

            base.OnGrab(grabber);

            // Never hold this item
            grab.DropItem(grabber, false, false);

            // Don't grab this if we are currently grabbing / remote grabbing a different item
            if (grabber.RemoteGrabbingItem || grabber.HoldingItem)
            {
                return;
            }

            // Grab the Parent Grabbable instead
            if (ParentGrabbable != null && !ParentGrabbable.BeingHeld)
            {
                grabber.GrabGrabbable(ParentGrabbable);
            }
        }
    }
}
