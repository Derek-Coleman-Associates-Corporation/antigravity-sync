# Universal API and Coding Rule
---
description: Global agent constraints for derek's environment
---

1. **Never use generic placeholder names** in scripts or API calls (e.g., `foo`, `bar`, `my-resource`). You must always query the Azure or GitHub environment dynamically to extract the true Active resource names (like `ai-project-sxhic5lc2tly4`).
2. **Always prefer Python SDKs** over raw CLI shell commands when deploying production infrastructure scripts.
3. **Never expose Public IPs** in Azure networking. All AI architecture must be strictly bound to virtual networks.
