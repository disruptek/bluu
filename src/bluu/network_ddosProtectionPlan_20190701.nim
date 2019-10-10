
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2019-07-01
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

  OpenApiRestCall_573641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573641): Option[Scheme] {.used.} =
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
  macServiceName = "network-ddosProtectionPlan"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DdosProtectionPlansList_573863 = ref object of OpenApiRestCall_573641
proc url_DdosProtectionPlansList_573865(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ddosProtectionPlans")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DdosProtectionPlansList_573864(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all DDoS protection plans in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574025 = path.getOrDefault("subscriptionId")
  valid_574025 = validateParameter(valid_574025, JString, required = true,
                                 default = nil)
  if valid_574025 != nil:
    section.add "subscriptionId", valid_574025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574026 = query.getOrDefault("api-version")
  valid_574026 = validateParameter(valid_574026, JString, required = true,
                                 default = nil)
  if valid_574026 != nil:
    section.add "api-version", valid_574026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574053: Call_DdosProtectionPlansList_573863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all DDoS protection plans in a subscription.
  ## 
  let valid = call_574053.validator(path, query, header, formData, body)
  let scheme = call_574053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574053.url(scheme.get, call_574053.host, call_574053.base,
                         call_574053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574053, url, valid)

proc call*(call_574124: Call_DdosProtectionPlansList_573863; apiVersion: string;
          subscriptionId: string): Recallable =
  ## ddosProtectionPlansList
  ## Gets all DDoS protection plans in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574125 = newJObject()
  var query_574127 = newJObject()
  add(query_574127, "api-version", newJString(apiVersion))
  add(path_574125, "subscriptionId", newJString(subscriptionId))
  result = call_574124.call(path_574125, query_574127, nil, nil, nil)

var ddosProtectionPlansList* = Call_DdosProtectionPlansList_573863(
    name: "ddosProtectionPlansList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/ddosProtectionPlans",
    validator: validate_DdosProtectionPlansList_573864, base: "",
    url: url_DdosProtectionPlansList_573865, schemes: {Scheme.Https})
type
  Call_DdosProtectionPlansListByResourceGroup_574166 = ref object of OpenApiRestCall_573641
proc url_DdosProtectionPlansListByResourceGroup_574168(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ddosProtectionPlans")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DdosProtectionPlansListByResourceGroup_574167(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the DDoS protection plans in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574169 = path.getOrDefault("resourceGroupName")
  valid_574169 = validateParameter(valid_574169, JString, required = true,
                                 default = nil)
  if valid_574169 != nil:
    section.add "resourceGroupName", valid_574169
  var valid_574170 = path.getOrDefault("subscriptionId")
  valid_574170 = validateParameter(valid_574170, JString, required = true,
                                 default = nil)
  if valid_574170 != nil:
    section.add "subscriptionId", valid_574170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574171 = query.getOrDefault("api-version")
  valid_574171 = validateParameter(valid_574171, JString, required = true,
                                 default = nil)
  if valid_574171 != nil:
    section.add "api-version", valid_574171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574172: Call_DdosProtectionPlansListByResourceGroup_574166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the DDoS protection plans in a resource group.
  ## 
  let valid = call_574172.validator(path, query, header, formData, body)
  let scheme = call_574172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574172.url(scheme.get, call_574172.host, call_574172.base,
                         call_574172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574172, url, valid)

proc call*(call_574173: Call_DdosProtectionPlansListByResourceGroup_574166;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## ddosProtectionPlansListByResourceGroup
  ## Gets all the DDoS protection plans in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574174 = newJObject()
  var query_574175 = newJObject()
  add(path_574174, "resourceGroupName", newJString(resourceGroupName))
  add(query_574175, "api-version", newJString(apiVersion))
  add(path_574174, "subscriptionId", newJString(subscriptionId))
  result = call_574173.call(path_574174, query_574175, nil, nil, nil)

var ddosProtectionPlansListByResourceGroup* = Call_DdosProtectionPlansListByResourceGroup_574166(
    name: "ddosProtectionPlansListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ddosProtectionPlans",
    validator: validate_DdosProtectionPlansListByResourceGroup_574167, base: "",
    url: url_DdosProtectionPlansListByResourceGroup_574168,
    schemes: {Scheme.Https})
type
  Call_DdosProtectionPlansCreateOrUpdate_574187 = ref object of OpenApiRestCall_573641
proc url_DdosProtectionPlansCreateOrUpdate_574189(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ddosProtectionPlanName" in path,
        "`ddosProtectionPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ddosProtectionPlans/"),
               (kind: VariableSegment, value: "ddosProtectionPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DdosProtectionPlansCreateOrUpdate_574188(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a DDoS protection plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosProtectionPlanName: JString (required)
  ##                         : The name of the DDoS protection plan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574216 = path.getOrDefault("resourceGroupName")
  valid_574216 = validateParameter(valid_574216, JString, required = true,
                                 default = nil)
  if valid_574216 != nil:
    section.add "resourceGroupName", valid_574216
  var valid_574217 = path.getOrDefault("subscriptionId")
  valid_574217 = validateParameter(valid_574217, JString, required = true,
                                 default = nil)
  if valid_574217 != nil:
    section.add "subscriptionId", valid_574217
  var valid_574218 = path.getOrDefault("ddosProtectionPlanName")
  valid_574218 = validateParameter(valid_574218, JString, required = true,
                                 default = nil)
  if valid_574218 != nil:
    section.add "ddosProtectionPlanName", valid_574218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574219 = query.getOrDefault("api-version")
  valid_574219 = validateParameter(valid_574219, JString, required = true,
                                 default = nil)
  if valid_574219 != nil:
    section.add "api-version", valid_574219
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

proc call*(call_574221: Call_DdosProtectionPlansCreateOrUpdate_574187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a DDoS protection plan.
  ## 
  let valid = call_574221.validator(path, query, header, formData, body)
  let scheme = call_574221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574221.url(scheme.get, call_574221.host, call_574221.base,
                         call_574221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574221, url, valid)

proc call*(call_574222: Call_DdosProtectionPlansCreateOrUpdate_574187;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          ddosProtectionPlanName: string; parameters: JsonNode): Recallable =
  ## ddosProtectionPlansCreateOrUpdate
  ## Creates or updates a DDoS protection plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosProtectionPlanName: string (required)
  ##                         : The name of the DDoS protection plan.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update operation.
  var path_574223 = newJObject()
  var query_574224 = newJObject()
  var body_574225 = newJObject()
  add(path_574223, "resourceGroupName", newJString(resourceGroupName))
  add(query_574224, "api-version", newJString(apiVersion))
  add(path_574223, "subscriptionId", newJString(subscriptionId))
  add(path_574223, "ddosProtectionPlanName", newJString(ddosProtectionPlanName))
  if parameters != nil:
    body_574225 = parameters
  result = call_574222.call(path_574223, query_574224, nil, nil, body_574225)

var ddosProtectionPlansCreateOrUpdate* = Call_DdosProtectionPlansCreateOrUpdate_574187(
    name: "ddosProtectionPlansCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ddosProtectionPlans/{ddosProtectionPlanName}",
    validator: validate_DdosProtectionPlansCreateOrUpdate_574188, base: "",
    url: url_DdosProtectionPlansCreateOrUpdate_574189, schemes: {Scheme.Https})
type
  Call_DdosProtectionPlansGet_574176 = ref object of OpenApiRestCall_573641
proc url_DdosProtectionPlansGet_574178(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ddosProtectionPlanName" in path,
        "`ddosProtectionPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ddosProtectionPlans/"),
               (kind: VariableSegment, value: "ddosProtectionPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DdosProtectionPlansGet_574177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified DDoS protection plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosProtectionPlanName: JString (required)
  ##                         : The name of the DDoS protection plan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574179 = path.getOrDefault("resourceGroupName")
  valid_574179 = validateParameter(valid_574179, JString, required = true,
                                 default = nil)
  if valid_574179 != nil:
    section.add "resourceGroupName", valid_574179
  var valid_574180 = path.getOrDefault("subscriptionId")
  valid_574180 = validateParameter(valid_574180, JString, required = true,
                                 default = nil)
  if valid_574180 != nil:
    section.add "subscriptionId", valid_574180
  var valid_574181 = path.getOrDefault("ddosProtectionPlanName")
  valid_574181 = validateParameter(valid_574181, JString, required = true,
                                 default = nil)
  if valid_574181 != nil:
    section.add "ddosProtectionPlanName", valid_574181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574182 = query.getOrDefault("api-version")
  valid_574182 = validateParameter(valid_574182, JString, required = true,
                                 default = nil)
  if valid_574182 != nil:
    section.add "api-version", valid_574182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574183: Call_DdosProtectionPlansGet_574176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified DDoS protection plan.
  ## 
  let valid = call_574183.validator(path, query, header, formData, body)
  let scheme = call_574183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574183.url(scheme.get, call_574183.host, call_574183.base,
                         call_574183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574183, url, valid)

proc call*(call_574184: Call_DdosProtectionPlansGet_574176;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          ddosProtectionPlanName: string): Recallable =
  ## ddosProtectionPlansGet
  ## Gets information about the specified DDoS protection plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosProtectionPlanName: string (required)
  ##                         : The name of the DDoS protection plan.
  var path_574185 = newJObject()
  var query_574186 = newJObject()
  add(path_574185, "resourceGroupName", newJString(resourceGroupName))
  add(query_574186, "api-version", newJString(apiVersion))
  add(path_574185, "subscriptionId", newJString(subscriptionId))
  add(path_574185, "ddosProtectionPlanName", newJString(ddosProtectionPlanName))
  result = call_574184.call(path_574185, query_574186, nil, nil, nil)

var ddosProtectionPlansGet* = Call_DdosProtectionPlansGet_574176(
    name: "ddosProtectionPlansGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ddosProtectionPlans/{ddosProtectionPlanName}",
    validator: validate_DdosProtectionPlansGet_574177, base: "",
    url: url_DdosProtectionPlansGet_574178, schemes: {Scheme.Https})
type
  Call_DdosProtectionPlansUpdateTags_574237 = ref object of OpenApiRestCall_573641
proc url_DdosProtectionPlansUpdateTags_574239(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ddosProtectionPlanName" in path,
        "`ddosProtectionPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ddosProtectionPlans/"),
               (kind: VariableSegment, value: "ddosProtectionPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DdosProtectionPlansUpdateTags_574238(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a DDoS protection plan tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosProtectionPlanName: JString (required)
  ##                         : The name of the DDoS protection plan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574240 = path.getOrDefault("resourceGroupName")
  valid_574240 = validateParameter(valid_574240, JString, required = true,
                                 default = nil)
  if valid_574240 != nil:
    section.add "resourceGroupName", valid_574240
  var valid_574241 = path.getOrDefault("subscriptionId")
  valid_574241 = validateParameter(valid_574241, JString, required = true,
                                 default = nil)
  if valid_574241 != nil:
    section.add "subscriptionId", valid_574241
  var valid_574242 = path.getOrDefault("ddosProtectionPlanName")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "ddosProtectionPlanName", valid_574242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574243 = query.getOrDefault("api-version")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "api-version", valid_574243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update DDoS protection plan resource tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574245: Call_DdosProtectionPlansUpdateTags_574237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a DDoS protection plan tags.
  ## 
  let valid = call_574245.validator(path, query, header, formData, body)
  let scheme = call_574245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574245.url(scheme.get, call_574245.host, call_574245.base,
                         call_574245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574245, url, valid)

proc call*(call_574246: Call_DdosProtectionPlansUpdateTags_574237;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          ddosProtectionPlanName: string; parameters: JsonNode): Recallable =
  ## ddosProtectionPlansUpdateTags
  ## Update a DDoS protection plan tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosProtectionPlanName: string (required)
  ##                         : The name of the DDoS protection plan.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update DDoS protection plan resource tags.
  var path_574247 = newJObject()
  var query_574248 = newJObject()
  var body_574249 = newJObject()
  add(path_574247, "resourceGroupName", newJString(resourceGroupName))
  add(query_574248, "api-version", newJString(apiVersion))
  add(path_574247, "subscriptionId", newJString(subscriptionId))
  add(path_574247, "ddosProtectionPlanName", newJString(ddosProtectionPlanName))
  if parameters != nil:
    body_574249 = parameters
  result = call_574246.call(path_574247, query_574248, nil, nil, body_574249)

var ddosProtectionPlansUpdateTags* = Call_DdosProtectionPlansUpdateTags_574237(
    name: "ddosProtectionPlansUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ddosProtectionPlans/{ddosProtectionPlanName}",
    validator: validate_DdosProtectionPlansUpdateTags_574238, base: "",
    url: url_DdosProtectionPlansUpdateTags_574239, schemes: {Scheme.Https})
type
  Call_DdosProtectionPlansDelete_574226 = ref object of OpenApiRestCall_573641
proc url_DdosProtectionPlansDelete_574228(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ddosProtectionPlanName" in path,
        "`ddosProtectionPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ddosProtectionPlans/"),
               (kind: VariableSegment, value: "ddosProtectionPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DdosProtectionPlansDelete_574227(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified DDoS protection plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosProtectionPlanName: JString (required)
  ##                         : The name of the DDoS protection plan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574229 = path.getOrDefault("resourceGroupName")
  valid_574229 = validateParameter(valid_574229, JString, required = true,
                                 default = nil)
  if valid_574229 != nil:
    section.add "resourceGroupName", valid_574229
  var valid_574230 = path.getOrDefault("subscriptionId")
  valid_574230 = validateParameter(valid_574230, JString, required = true,
                                 default = nil)
  if valid_574230 != nil:
    section.add "subscriptionId", valid_574230
  var valid_574231 = path.getOrDefault("ddosProtectionPlanName")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "ddosProtectionPlanName", valid_574231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574232 = query.getOrDefault("api-version")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "api-version", valid_574232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574233: Call_DdosProtectionPlansDelete_574226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified DDoS protection plan.
  ## 
  let valid = call_574233.validator(path, query, header, formData, body)
  let scheme = call_574233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574233.url(scheme.get, call_574233.host, call_574233.base,
                         call_574233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574233, url, valid)

proc call*(call_574234: Call_DdosProtectionPlansDelete_574226;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          ddosProtectionPlanName: string): Recallable =
  ## ddosProtectionPlansDelete
  ## Deletes the specified DDoS protection plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosProtectionPlanName: string (required)
  ##                         : The name of the DDoS protection plan.
  var path_574235 = newJObject()
  var query_574236 = newJObject()
  add(path_574235, "resourceGroupName", newJString(resourceGroupName))
  add(query_574236, "api-version", newJString(apiVersion))
  add(path_574235, "subscriptionId", newJString(subscriptionId))
  add(path_574235, "ddosProtectionPlanName", newJString(ddosProtectionPlanName))
  result = call_574234.call(path_574235, query_574236, nil, nil, nil)

var ddosProtectionPlansDelete* = Call_DdosProtectionPlansDelete_574226(
    name: "ddosProtectionPlansDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ddosProtectionPlans/{ddosProtectionPlanName}",
    validator: validate_DdosProtectionPlansDelete_574227, base: "",
    url: url_DdosProtectionPlansDelete_574228, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
