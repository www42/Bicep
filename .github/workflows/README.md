## Spaces in variable value

```yaml
env:
  region: "West Europe"

  ${{ env.region }}      # This does not work!
```

```yaml
env:
  region: West Europe

  "${{ env.region }}"    # Ok.
```