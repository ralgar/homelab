# Deployment: admin

The `admin` deployment is how we bootstrap the cloud. It is here that we deploy
 shared resources such as networks, images, flavors, and templates.

---

## Initial Deployment

### Configuration via Merge Request

1. Open a new Merge Request (against your own repository), and configure the
   resources under `infra/deployments/admin/networks` to suit your environment.
   Also, don't forget to adjust the external network for the CoE templates.

1. You can deploy a dev environment from the MR page to test your changes, but
   note that the networks will not be deployed here due to conflicts with prod.

1. Once you're satisfied, merge the changes to the main branch to trigger the
   prod deployment pipeline.

### Deploying to Production

As you watch the pipeline graph progress, you will notice that it stops before
 the final job, called `terraform:apply`. The pipeline stops at this stage so
 that you have a chance to review the Terraform plan one final time.

To view the plan, click on the `terraform:plan` job to see its log.

If you are satisfied with the plan, head back to the pipeline graph, and click
 the *Play* button next to the `terraform:apply` job. The deployment can take
 several minutes to complete.

If all goes well, you will see a green checkmark appear like the other jobs.
 This indicates that you have successfully deployed the production environment!
