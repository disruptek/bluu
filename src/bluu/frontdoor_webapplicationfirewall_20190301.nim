
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: WebApplicationFirewallManagement
## version: 2019-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## APIs to manage web application firewall rules
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_573658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573658): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "frontdoor-webapplicationfirewall"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ManagedRuleSetsList_573880 = ref object of OpenApiRestCall_573658
proc url_ManagedRuleSetsList_573882(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/FrontDoorWebApplicationFirewallManagedRuleSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedRuleSetsList_573881(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists all available managed rule sets.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574042 = path.getOrDefault("subscriptionId")
  valid_574042 = validateParameter(valid_574042, JString, required = true,
                                 default = nil)
  if valid_574042 != nil:
    section.add "subscriptionId", valid_574042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574043 = query.getOrDefault("api-version")
  valid_574043 = validateParameter(valid_574043, JString, required = true,
                                 default = nil)
  if valid_574043 != nil:
    section.add "api-version", valid_574043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574070: Call_ManagedRuleSetsList_573880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all available managed rule sets.
  ## 
  let valid = call_574070.validator(path, query, header, formData, body)
  let scheme = call_574070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574070.url(scheme.get, call_574070.host, call_574070.base,
                         call_574070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574070, url, valid)

proc call*(call_574141: Call_ManagedRuleSetsList_573880; apiVersion: string;
          subscriptionId: string): Recallable =
  ## managedRuleSetsList
  ## Lists all available managed rule sets.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574142 = newJObject()
  var query_574144 = newJObject()
  add(query_574144, "api-version", newJString(apiVersion))
  add(path_574142, "subscriptionId", newJString(subscriptionId))
  result = call_574141.call(path_574142, query_574144, nil, nil, nil)

var managedRuleSetsList* = Call_ManagedRuleSetsList_573880(
    name: "managedRuleSetsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/FrontDoorWebApplicationFirewallManagedRuleSets",
    validator: validate_ManagedRuleSetsList_573881, base: "",
    url: url_ManagedRuleSetsList_573882, schemes: {Scheme.Https})
type
  Call_PoliciesList_574183 = ref object of OpenApiRestCall_573658
proc url_PoliciesList_574185(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/FrontDoorWebApplicationFirewallPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesList_574184(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the protection policies within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574195 = path.getOrDefault("resourceGroupName")
  valid_574195 = validateParameter(valid_574195, JString, required = true,
                                 default = nil)
  if valid_574195 != nil:
    section.add "resourceGroupName", valid_574195
  var valid_574196 = path.getOrDefault("subscriptionId")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "subscriptionId", valid_574196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574197 = query.getOrDefault("api-version")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "api-version", valid_574197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574198: Call_PoliciesList_574183; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the protection policies within a resource group.
  ## 
  let valid = call_574198.validator(path, query, header, formData, body)
  let scheme = call_574198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574198.url(scheme.get, call_574198.host, call_574198.base,
                         call_574198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574198, url, valid)

proc call*(call_574199: Call_PoliciesList_574183; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## policiesList
  ## Lists all of the protection policies within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574200 = newJObject()
  var query_574201 = newJObject()
  add(path_574200, "resourceGroupName", newJString(resourceGroupName))
  add(query_574201, "api-version", newJString(apiVersion))
  add(path_574200, "subscriptionId", newJString(subscriptionId))
  result = call_574199.call(path_574200, query_574201, nil, nil, nil)

var policiesList* = Call_PoliciesList_574183(name: "policiesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/FrontDoorWebApplicationFirewallPolicies",
    validator: validate_PoliciesList_574184, base: "", url: url_PoliciesList_574185,
    schemes: {Scheme.Https})
type
  Call_PoliciesCreateOrUpdate_574213 = ref object of OpenApiRestCall_573658
proc url_PoliciesCreateOrUpdate_574215(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/FrontDoorWebApplicationFirewallPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesCreateOrUpdate_574214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update policy with specified rule set name within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyName: JString (required)
  ##             : The name of the Web Application Firewall Policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574233 = path.getOrDefault("resourceGroupName")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "resourceGroupName", valid_574233
  var valid_574234 = path.getOrDefault("subscriptionId")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "subscriptionId", valid_574234
  var valid_574235 = path.getOrDefault("policyName")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "policyName", valid_574235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574236 = query.getOrDefault("api-version")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "api-version", valid_574236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Policy to be created.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574238: Call_PoliciesCreateOrUpdate_574213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update policy with specified rule set name within a resource group.
  ## 
  let valid = call_574238.validator(path, query, header, formData, body)
  let scheme = call_574238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574238.url(scheme.get, call_574238.host, call_574238.base,
                         call_574238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574238, url, valid)

proc call*(call_574239: Call_PoliciesCreateOrUpdate_574213;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; parameters: JsonNode): Recallable =
  ## policiesCreateOrUpdate
  ## Create or update policy with specified rule set name within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyName: string (required)
  ##             : The name of the Web Application Firewall Policy.
  ##   parameters: JObject (required)
  ##             : Policy to be created.
  var path_574240 = newJObject()
  var query_574241 = newJObject()
  var body_574242 = newJObject()
  add(path_574240, "resourceGroupName", newJString(resourceGroupName))
  add(query_574241, "api-version", newJString(apiVersion))
  add(path_574240, "subscriptionId", newJString(subscriptionId))
  add(path_574240, "policyName", newJString(policyName))
  if parameters != nil:
    body_574242 = parameters
  result = call_574239.call(path_574240, query_574241, nil, nil, body_574242)

var policiesCreateOrUpdate* = Call_PoliciesCreateOrUpdate_574213(
    name: "policiesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/FrontDoorWebApplicationFirewallPolicies/{policyName}",
    validator: validate_PoliciesCreateOrUpdate_574214, base: "",
    url: url_PoliciesCreateOrUpdate_574215, schemes: {Scheme.Https})
type
  Call_PoliciesGet_574202 = ref object of OpenApiRestCall_573658
proc url_PoliciesGet_574204(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/FrontDoorWebApplicationFirewallPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesGet_574203(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve protection policy with specified name within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyName: JString (required)
  ##             : The name of the Web Application Firewall Policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574205 = path.getOrDefault("resourceGroupName")
  valid_574205 = validateParameter(valid_574205, JString, required = true,
                                 default = nil)
  if valid_574205 != nil:
    section.add "resourceGroupName", valid_574205
  var valid_574206 = path.getOrDefault("subscriptionId")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = nil)
  if valid_574206 != nil:
    section.add "subscriptionId", valid_574206
  var valid_574207 = path.getOrDefault("policyName")
  valid_574207 = validateParameter(valid_574207, JString, required = true,
                                 default = nil)
  if valid_574207 != nil:
    section.add "policyName", valid_574207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574208 = query.getOrDefault("api-version")
  valid_574208 = validateParameter(valid_574208, JString, required = true,
                                 default = nil)
  if valid_574208 != nil:
    section.add "api-version", valid_574208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574209: Call_PoliciesGet_574202; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve protection policy with specified name within a resource group.
  ## 
  let valid = call_574209.validator(path, query, header, formData, body)
  let scheme = call_574209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574209.url(scheme.get, call_574209.host, call_574209.base,
                         call_574209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574209, url, valid)

proc call*(call_574210: Call_PoliciesGet_574202; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; policyName: string): Recallable =
  ## policiesGet
  ## Retrieve protection policy with specified name within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyName: string (required)
  ##             : The name of the Web Application Firewall Policy.
  var path_574211 = newJObject()
  var query_574212 = newJObject()
  add(path_574211, "resourceGroupName", newJString(resourceGroupName))
  add(query_574212, "api-version", newJString(apiVersion))
  add(path_574211, "subscriptionId", newJString(subscriptionId))
  add(path_574211, "policyName", newJString(policyName))
  result = call_574210.call(path_574211, query_574212, nil, nil, nil)

var policiesGet* = Call_PoliciesGet_574202(name: "policiesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/FrontDoorWebApplicationFirewallPolicies/{policyName}",
                                        validator: validate_PoliciesGet_574203,
                                        base: "", url: url_PoliciesGet_574204,
                                        schemes: {Scheme.Https})
type
  Call_PoliciesDelete_574243 = ref object of OpenApiRestCall_573658
proc url_PoliciesDelete_574245(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/FrontDoorWebApplicationFirewallPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesDelete_574244(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes Policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyName: JString (required)
  ##             : The name of the Web Application Firewall Policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574246 = path.getOrDefault("resourceGroupName")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "resourceGroupName", valid_574246
  var valid_574247 = path.getOrDefault("subscriptionId")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "subscriptionId", valid_574247
  var valid_574248 = path.getOrDefault("policyName")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "policyName", valid_574248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574249 = query.getOrDefault("api-version")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "api-version", valid_574249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574250: Call_PoliciesDelete_574243; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes Policy
  ## 
  let valid = call_574250.validator(path, query, header, formData, body)
  let scheme = call_574250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574250.url(scheme.get, call_574250.host, call_574250.base,
                         call_574250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574250, url, valid)

proc call*(call_574251: Call_PoliciesDelete_574243; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; policyName: string): Recallable =
  ## policiesDelete
  ## Deletes Policy
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyName: string (required)
  ##             : The name of the Web Application Firewall Policy.
  var path_574252 = newJObject()
  var query_574253 = newJObject()
  add(path_574252, "resourceGroupName", newJString(resourceGroupName))
  add(query_574253, "api-version", newJString(apiVersion))
  add(path_574252, "subscriptionId", newJString(subscriptionId))
  add(path_574252, "policyName", newJString(policyName))
  result = call_574251.call(path_574252, query_574253, nil, nil, nil)

var policiesDelete* = Call_PoliciesDelete_574243(name: "policiesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/FrontDoorWebApplicationFirewallPolicies/{policyName}",
    validator: validate_PoliciesDelete_574244, base: "", url: url_PoliciesDelete_574245,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
