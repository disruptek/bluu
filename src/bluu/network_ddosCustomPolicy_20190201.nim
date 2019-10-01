
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2019-02-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Microsoft Azure Network management API provides a RESTful set of web services that interact with Microsoft Azure Networks service to manage your network resources. The API has entities that capture the relationship between an end user and the Microsoft Azure Networks service.
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "network-ddosCustomPolicy"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DdosCustomPoliciesCreateOrUpdate_568168 = ref object of OpenApiRestCall_567641
proc url_DdosCustomPoliciesCreateOrUpdate_568170(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ddosCustomPolicyName" in path,
        "`ddosCustomPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ddosCustomPolicies/"),
               (kind: VariableSegment, value: "ddosCustomPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DdosCustomPoliciesCreateOrUpdate_568169(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a DDoS custom policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosCustomPolicyName: JString (required)
  ##                       : The name of the DDoS custom policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568197 = path.getOrDefault("resourceGroupName")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "resourceGroupName", valid_568197
  var valid_568198 = path.getOrDefault("subscriptionId")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "subscriptionId", valid_568198
  var valid_568199 = path.getOrDefault("ddosCustomPolicyName")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "ddosCustomPolicyName", valid_568199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568200 = query.getOrDefault("api-version")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "api-version", valid_568200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568202: Call_DdosCustomPoliciesCreateOrUpdate_568168;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a DDoS custom policy.
  ## 
  let valid = call_568202.validator(path, query, header, formData, body)
  let scheme = call_568202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568202.url(scheme.get, call_568202.host, call_568202.base,
                         call_568202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568202, url, valid)

proc call*(call_568203: Call_DdosCustomPoliciesCreateOrUpdate_568168;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          ddosCustomPolicyName: string; parameters: JsonNode): Recallable =
  ## ddosCustomPoliciesCreateOrUpdate
  ## Creates or updates a DDoS custom policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosCustomPolicyName: string (required)
  ##                       : The name of the DDoS custom policy.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update operation.
  var path_568204 = newJObject()
  var query_568205 = newJObject()
  var body_568206 = newJObject()
  add(path_568204, "resourceGroupName", newJString(resourceGroupName))
  add(query_568205, "api-version", newJString(apiVersion))
  add(path_568204, "subscriptionId", newJString(subscriptionId))
  add(path_568204, "ddosCustomPolicyName", newJString(ddosCustomPolicyName))
  if parameters != nil:
    body_568206 = parameters
  result = call_568203.call(path_568204, query_568205, nil, nil, body_568206)

var ddosCustomPoliciesCreateOrUpdate* = Call_DdosCustomPoliciesCreateOrUpdate_568168(
    name: "ddosCustomPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ddosCustomPolicies/{ddosCustomPolicyName}",
    validator: validate_DdosCustomPoliciesCreateOrUpdate_568169, base: "",
    url: url_DdosCustomPoliciesCreateOrUpdate_568170, schemes: {Scheme.Https})
type
  Call_DdosCustomPoliciesGet_567863 = ref object of OpenApiRestCall_567641
proc url_DdosCustomPoliciesGet_567865(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ddosCustomPolicyName" in path,
        "`ddosCustomPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ddosCustomPolicies/"),
               (kind: VariableSegment, value: "ddosCustomPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DdosCustomPoliciesGet_567864(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified DDoS custom policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosCustomPolicyName: JString (required)
  ##                       : The name of the DDoS custom policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568025 = path.getOrDefault("resourceGroupName")
  valid_568025 = validateParameter(valid_568025, JString, required = true,
                                 default = nil)
  if valid_568025 != nil:
    section.add "resourceGroupName", valid_568025
  var valid_568026 = path.getOrDefault("subscriptionId")
  valid_568026 = validateParameter(valid_568026, JString, required = true,
                                 default = nil)
  if valid_568026 != nil:
    section.add "subscriptionId", valid_568026
  var valid_568027 = path.getOrDefault("ddosCustomPolicyName")
  valid_568027 = validateParameter(valid_568027, JString, required = true,
                                 default = nil)
  if valid_568027 != nil:
    section.add "ddosCustomPolicyName", valid_568027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568028 = query.getOrDefault("api-version")
  valid_568028 = validateParameter(valid_568028, JString, required = true,
                                 default = nil)
  if valid_568028 != nil:
    section.add "api-version", valid_568028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568055: Call_DdosCustomPoliciesGet_567863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified DDoS custom policy.
  ## 
  let valid = call_568055.validator(path, query, header, formData, body)
  let scheme = call_568055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568055.url(scheme.get, call_568055.host, call_568055.base,
                         call_568055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568055, url, valid)

proc call*(call_568126: Call_DdosCustomPoliciesGet_567863;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          ddosCustomPolicyName: string): Recallable =
  ## ddosCustomPoliciesGet
  ## Gets information about the specified DDoS custom policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosCustomPolicyName: string (required)
  ##                       : The name of the DDoS custom policy.
  var path_568127 = newJObject()
  var query_568129 = newJObject()
  add(path_568127, "resourceGroupName", newJString(resourceGroupName))
  add(query_568129, "api-version", newJString(apiVersion))
  add(path_568127, "subscriptionId", newJString(subscriptionId))
  add(path_568127, "ddosCustomPolicyName", newJString(ddosCustomPolicyName))
  result = call_568126.call(path_568127, query_568129, nil, nil, nil)

var ddosCustomPoliciesGet* = Call_DdosCustomPoliciesGet_567863(
    name: "ddosCustomPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ddosCustomPolicies/{ddosCustomPolicyName}",
    validator: validate_DdosCustomPoliciesGet_567864, base: "",
    url: url_DdosCustomPoliciesGet_567865, schemes: {Scheme.Https})
type
  Call_DdosCustomPoliciesUpdateTags_568218 = ref object of OpenApiRestCall_567641
proc url_DdosCustomPoliciesUpdateTags_568220(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ddosCustomPolicyName" in path,
        "`ddosCustomPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ddosCustomPolicies/"),
               (kind: VariableSegment, value: "ddosCustomPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DdosCustomPoliciesUpdateTags_568219(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a DDoS custom policy tags
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosCustomPolicyName: JString (required)
  ##                       : The name of the DDoS custom policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568221 = path.getOrDefault("resourceGroupName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "resourceGroupName", valid_568221
  var valid_568222 = path.getOrDefault("subscriptionId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "subscriptionId", valid_568222
  var valid_568223 = path.getOrDefault("ddosCustomPolicyName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "ddosCustomPolicyName", valid_568223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568224 = query.getOrDefault("api-version")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "api-version", valid_568224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update DDoS custom policy resource tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568226: Call_DdosCustomPoliciesUpdateTags_568218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a DDoS custom policy tags
  ## 
  let valid = call_568226.validator(path, query, header, formData, body)
  let scheme = call_568226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568226.url(scheme.get, call_568226.host, call_568226.base,
                         call_568226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568226, url, valid)

proc call*(call_568227: Call_DdosCustomPoliciesUpdateTags_568218;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          ddosCustomPolicyName: string; parameters: JsonNode): Recallable =
  ## ddosCustomPoliciesUpdateTags
  ## Update a DDoS custom policy tags
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosCustomPolicyName: string (required)
  ##                       : The name of the DDoS custom policy.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update DDoS custom policy resource tags.
  var path_568228 = newJObject()
  var query_568229 = newJObject()
  var body_568230 = newJObject()
  add(path_568228, "resourceGroupName", newJString(resourceGroupName))
  add(query_568229, "api-version", newJString(apiVersion))
  add(path_568228, "subscriptionId", newJString(subscriptionId))
  add(path_568228, "ddosCustomPolicyName", newJString(ddosCustomPolicyName))
  if parameters != nil:
    body_568230 = parameters
  result = call_568227.call(path_568228, query_568229, nil, nil, body_568230)

var ddosCustomPoliciesUpdateTags* = Call_DdosCustomPoliciesUpdateTags_568218(
    name: "ddosCustomPoliciesUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ddosCustomPolicies/{ddosCustomPolicyName}",
    validator: validate_DdosCustomPoliciesUpdateTags_568219, base: "",
    url: url_DdosCustomPoliciesUpdateTags_568220, schemes: {Scheme.Https})
type
  Call_DdosCustomPoliciesDelete_568207 = ref object of OpenApiRestCall_567641
proc url_DdosCustomPoliciesDelete_568209(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ddosCustomPolicyName" in path,
        "`ddosCustomPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ddosCustomPolicies/"),
               (kind: VariableSegment, value: "ddosCustomPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DdosCustomPoliciesDelete_568208(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified DDoS custom policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosCustomPolicyName: JString (required)
  ##                       : The name of the DDoS custom policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568210 = path.getOrDefault("resourceGroupName")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "resourceGroupName", valid_568210
  var valid_568211 = path.getOrDefault("subscriptionId")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "subscriptionId", valid_568211
  var valid_568212 = path.getOrDefault("ddosCustomPolicyName")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "ddosCustomPolicyName", valid_568212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568213 = query.getOrDefault("api-version")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "api-version", valid_568213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568214: Call_DdosCustomPoliciesDelete_568207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified DDoS custom policy.
  ## 
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_DdosCustomPoliciesDelete_568207;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          ddosCustomPolicyName: string): Recallable =
  ## ddosCustomPoliciesDelete
  ## Deletes the specified DDoS custom policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosCustomPolicyName: string (required)
  ##                       : The name of the DDoS custom policy.
  var path_568216 = newJObject()
  var query_568217 = newJObject()
  add(path_568216, "resourceGroupName", newJString(resourceGroupName))
  add(query_568217, "api-version", newJString(apiVersion))
  add(path_568216, "subscriptionId", newJString(subscriptionId))
  add(path_568216, "ddosCustomPolicyName", newJString(ddosCustomPolicyName))
  result = call_568215.call(path_568216, query_568217, nil, nil, nil)

var ddosCustomPoliciesDelete* = Call_DdosCustomPoliciesDelete_568207(
    name: "ddosCustomPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ddosCustomPolicies/{ddosCustomPolicyName}",
    validator: validate_DdosCustomPoliciesDelete_568208, base: "",
    url: url_DdosCustomPoliciesDelete_568209, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
