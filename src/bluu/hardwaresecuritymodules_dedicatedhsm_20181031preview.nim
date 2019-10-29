
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Dedicated HSM Resource Provider
## version: 2018-10-31-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure management API provides a RESTful set of web services that interact with Azure Dedicated HSM RP.
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "hardwaresecuritymodules-dedicatedhsm"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DedicatedHsmListBySubscription_563761 = ref object of OpenApiRestCall_563539
proc url_DedicatedHsmListBySubscription_563763(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HardwareSecurityModules/dedicatedHSMs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedHsmListBySubscription_563762(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List operation gets information about the dedicated HSMs associated with the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563939 = path.getOrDefault("subscriptionId")
  valid_563939 = validateParameter(valid_563939, JString, required = true,
                                 default = nil)
  if valid_563939 != nil:
    section.add "subscriptionId", valid_563939
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Maximum number of results to return.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_563940 = query.getOrDefault("$top")
  valid_563940 = validateParameter(valid_563940, JInt, required = false, default = nil)
  if valid_563940 != nil:
    section.add "$top", valid_563940
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563941 = query.getOrDefault("api-version")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "api-version", valid_563941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_DedicatedHsmListBySubscription_563761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List operation gets information about the dedicated HSMs associated with the subscription.
  ## 
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_DedicatedHsmListBySubscription_563761;
          apiVersion: string; subscriptionId: string; Top: int = 0): Recallable =
  ## dedicatedHsmListBySubscription
  ## The List operation gets information about the dedicated HSMs associated with the subscription.
  ##   Top: int
  ##      : Maximum number of results to return.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564036 = newJObject()
  var query_564038 = newJObject()
  add(query_564038, "$top", newJInt(Top))
  add(query_564038, "api-version", newJString(apiVersion))
  add(path_564036, "subscriptionId", newJString(subscriptionId))
  result = call_564035.call(path_564036, query_564038, nil, nil, nil)

var dedicatedHsmListBySubscription* = Call_DedicatedHsmListBySubscription_563761(
    name: "dedicatedHsmListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.HardwareSecurityModules/dedicatedHSMs",
    validator: validate_DedicatedHsmListBySubscription_563762, base: "",
    url: url_DedicatedHsmListBySubscription_563763, schemes: {Scheme.Https})
type
  Call_DedicatedHsmListByResourceGroup_564077 = ref object of OpenApiRestCall_563539
proc url_DedicatedHsmListByResourceGroup_564079(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.HardwareSecurityModules/dedicatedHSMs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedHsmListByResourceGroup_564078(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List operation gets information about the dedicated hsms associated with the subscription and within the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the dedicated HSM belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564080 = path.getOrDefault("subscriptionId")
  valid_564080 = validateParameter(valid_564080, JString, required = true,
                                 default = nil)
  if valid_564080 != nil:
    section.add "subscriptionId", valid_564080
  var valid_564081 = path.getOrDefault("resourceGroupName")
  valid_564081 = validateParameter(valid_564081, JString, required = true,
                                 default = nil)
  if valid_564081 != nil:
    section.add "resourceGroupName", valid_564081
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Maximum number of results to return.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_564082 = query.getOrDefault("$top")
  valid_564082 = validateParameter(valid_564082, JInt, required = false, default = nil)
  if valid_564082 != nil:
    section.add "$top", valid_564082
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564083 = query.getOrDefault("api-version")
  valid_564083 = validateParameter(valid_564083, JString, required = true,
                                 default = nil)
  if valid_564083 != nil:
    section.add "api-version", valid_564083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564084: Call_DedicatedHsmListByResourceGroup_564077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List operation gets information about the dedicated hsms associated with the subscription and within the specified resource group.
  ## 
  let valid = call_564084.validator(path, query, header, formData, body)
  let scheme = call_564084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564084.url(scheme.get, call_564084.host, call_564084.base,
                         call_564084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564084, url, valid)

proc call*(call_564085: Call_DedicatedHsmListByResourceGroup_564077;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0): Recallable =
  ## dedicatedHsmListByResourceGroup
  ## The List operation gets information about the dedicated hsms associated with the subscription and within the specified resource group.
  ##   Top: int
  ##      : Maximum number of results to return.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the dedicated HSM belongs.
  var path_564086 = newJObject()
  var query_564087 = newJObject()
  add(query_564087, "$top", newJInt(Top))
  add(query_564087, "api-version", newJString(apiVersion))
  add(path_564086, "subscriptionId", newJString(subscriptionId))
  add(path_564086, "resourceGroupName", newJString(resourceGroupName))
  result = call_564085.call(path_564086, query_564087, nil, nil, nil)

var dedicatedHsmListByResourceGroup* = Call_DedicatedHsmListByResourceGroup_564077(
    name: "dedicatedHsmListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HardwareSecurityModules/dedicatedHSMs",
    validator: validate_DedicatedHsmListByResourceGroup_564078, base: "",
    url: url_DedicatedHsmListByResourceGroup_564079, schemes: {Scheme.Https})
type
  Call_DedicatedHsmCreateOrUpdate_564099 = ref object of OpenApiRestCall_563539
proc url_DedicatedHsmCreateOrUpdate_564101(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HardwareSecurityModules/dedicatedHSMs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedHsmCreateOrUpdate_564100(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or Update a dedicated HSM in the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the dedicated Hsm
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564119 = path.getOrDefault("name")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "name", valid_564119
  var valid_564120 = path.getOrDefault("subscriptionId")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "subscriptionId", valid_564120
  var valid_564121 = path.getOrDefault("resourceGroupName")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "resourceGroupName", valid_564121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564122 = query.getOrDefault("api-version")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "api-version", valid_564122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to create or update the dedicated hsm
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564124: Call_DedicatedHsmCreateOrUpdate_564099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or Update a dedicated HSM in the specified subscription.
  ## 
  let valid = call_564124.validator(path, query, header, formData, body)
  let scheme = call_564124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564124.url(scheme.get, call_564124.host, call_564124.base,
                         call_564124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564124, url, valid)

proc call*(call_564125: Call_DedicatedHsmCreateOrUpdate_564099; apiVersion: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## dedicatedHsmCreateOrUpdate
  ## Create or Update a dedicated HSM in the specified subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : Name of the dedicated Hsm
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the resource belongs.
  ##   parameters: JObject (required)
  ##             : Parameters to create or update the dedicated hsm
  var path_564126 = newJObject()
  var query_564127 = newJObject()
  var body_564128 = newJObject()
  add(query_564127, "api-version", newJString(apiVersion))
  add(path_564126, "name", newJString(name))
  add(path_564126, "subscriptionId", newJString(subscriptionId))
  add(path_564126, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564128 = parameters
  result = call_564125.call(path_564126, query_564127, nil, nil, body_564128)

var dedicatedHsmCreateOrUpdate* = Call_DedicatedHsmCreateOrUpdate_564099(
    name: "dedicatedHsmCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HardwareSecurityModules/dedicatedHSMs/{name}",
    validator: validate_DedicatedHsmCreateOrUpdate_564100, base: "",
    url: url_DedicatedHsmCreateOrUpdate_564101, schemes: {Scheme.Https})
type
  Call_DedicatedHsmGet_564088 = ref object of OpenApiRestCall_563539
proc url_DedicatedHsmGet_564090(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HardwareSecurityModules/dedicatedHSMs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedHsmGet_564089(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the specified Azure dedicated HSM.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the dedicated HSM.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the dedicated hsm belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564091 = path.getOrDefault("name")
  valid_564091 = validateParameter(valid_564091, JString, required = true,
                                 default = nil)
  if valid_564091 != nil:
    section.add "name", valid_564091
  var valid_564092 = path.getOrDefault("subscriptionId")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = nil)
  if valid_564092 != nil:
    section.add "subscriptionId", valid_564092
  var valid_564093 = path.getOrDefault("resourceGroupName")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "resourceGroupName", valid_564093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564094 = query.getOrDefault("api-version")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "api-version", valid_564094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564095: Call_DedicatedHsmGet_564088; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Azure dedicated HSM.
  ## 
  let valid = call_564095.validator(path, query, header, formData, body)
  let scheme = call_564095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564095.url(scheme.get, call_564095.host, call_564095.base,
                         call_564095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564095, url, valid)

proc call*(call_564096: Call_DedicatedHsmGet_564088; apiVersion: string;
          name: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## dedicatedHsmGet
  ## Gets the specified Azure dedicated HSM.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : The name of the dedicated HSM.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the dedicated hsm belongs.
  var path_564097 = newJObject()
  var query_564098 = newJObject()
  add(query_564098, "api-version", newJString(apiVersion))
  add(path_564097, "name", newJString(name))
  add(path_564097, "subscriptionId", newJString(subscriptionId))
  add(path_564097, "resourceGroupName", newJString(resourceGroupName))
  result = call_564096.call(path_564097, query_564098, nil, nil, nil)

var dedicatedHsmGet* = Call_DedicatedHsmGet_564088(name: "dedicatedHsmGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HardwareSecurityModules/dedicatedHSMs/{name}",
    validator: validate_DedicatedHsmGet_564089, base: "", url: url_DedicatedHsmGet_564090,
    schemes: {Scheme.Https})
type
  Call_DedicatedHsmUpdate_564140 = ref object of OpenApiRestCall_563539
proc url_DedicatedHsmUpdate_564142(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HardwareSecurityModules/dedicatedHSMs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedHsmUpdate_564141(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Update a dedicated HSM in the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the dedicated HSM
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the server belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564143 = path.getOrDefault("name")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "name", valid_564143
  var valid_564144 = path.getOrDefault("subscriptionId")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "subscriptionId", valid_564144
  var valid_564145 = path.getOrDefault("resourceGroupName")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "resourceGroupName", valid_564145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564146 = query.getOrDefault("api-version")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "api-version", valid_564146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to patch the dedicated HSM
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564148: Call_DedicatedHsmUpdate_564140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a dedicated HSM in the specified subscription.
  ## 
  let valid = call_564148.validator(path, query, header, formData, body)
  let scheme = call_564148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564148.url(scheme.get, call_564148.host, call_564148.base,
                         call_564148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564148, url, valid)

proc call*(call_564149: Call_DedicatedHsmUpdate_564140; apiVersion: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## dedicatedHsmUpdate
  ## Update a dedicated HSM in the specified subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : Name of the dedicated HSM
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the server belongs.
  ##   parameters: JObject (required)
  ##             : Parameters to patch the dedicated HSM
  var path_564150 = newJObject()
  var query_564151 = newJObject()
  var body_564152 = newJObject()
  add(query_564151, "api-version", newJString(apiVersion))
  add(path_564150, "name", newJString(name))
  add(path_564150, "subscriptionId", newJString(subscriptionId))
  add(path_564150, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564152 = parameters
  result = call_564149.call(path_564150, query_564151, nil, nil, body_564152)

var dedicatedHsmUpdate* = Call_DedicatedHsmUpdate_564140(
    name: "dedicatedHsmUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HardwareSecurityModules/dedicatedHSMs/{name}",
    validator: validate_DedicatedHsmUpdate_564141, base: "",
    url: url_DedicatedHsmUpdate_564142, schemes: {Scheme.Https})
type
  Call_DedicatedHsmDelete_564129 = ref object of OpenApiRestCall_563539
proc url_DedicatedHsmDelete_564131(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HardwareSecurityModules/dedicatedHSMs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedHsmDelete_564130(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the specified Azure Dedicated HSM.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the dedicated HSM to delete
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the dedicated HSM belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564132 = path.getOrDefault("name")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "name", valid_564132
  var valid_564133 = path.getOrDefault("subscriptionId")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "subscriptionId", valid_564133
  var valid_564134 = path.getOrDefault("resourceGroupName")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "resourceGroupName", valid_564134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564135 = query.getOrDefault("api-version")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "api-version", valid_564135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564136: Call_DedicatedHsmDelete_564129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Azure Dedicated HSM.
  ## 
  let valid = call_564136.validator(path, query, header, formData, body)
  let scheme = call_564136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564136.url(scheme.get, call_564136.host, call_564136.base,
                         call_564136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564136, url, valid)

proc call*(call_564137: Call_DedicatedHsmDelete_564129; apiVersion: string;
          name: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## dedicatedHsmDelete
  ## Deletes the specified Azure Dedicated HSM.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : The name of the dedicated HSM to delete
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the dedicated HSM belongs.
  var path_564138 = newJObject()
  var query_564139 = newJObject()
  add(query_564139, "api-version", newJString(apiVersion))
  add(path_564138, "name", newJString(name))
  add(path_564138, "subscriptionId", newJString(subscriptionId))
  add(path_564138, "resourceGroupName", newJString(resourceGroupName))
  result = call_564137.call(path_564138, query_564139, nil, nil, nil)

var dedicatedHsmDelete* = Call_DedicatedHsmDelete_564129(
    name: "dedicatedHsmDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HardwareSecurityModules/dedicatedHSMs/{name}",
    validator: validate_DedicatedHsmDelete_564130, base: "",
    url: url_DedicatedHsmDelete_564131, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
