
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Mixed Reality
## version: 2019-02-28-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Mixed Reality Resource Provider REST API
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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "mixedreality"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567880 = ref object of OpenApiRestCall_567658
proc url_OperationsList_567882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567881(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Exposing Available Operations
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568041 = query.getOrDefault("api-version")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "api-version", valid_568041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568064: Call_OperationsList_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exposing Available Operations
  ## 
  let valid = call_568064.validator(path, query, header, formData, body)
  let scheme = call_568064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568064.url(scheme.get, call_568064.host, call_568064.base,
                         call_568064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568064, url, valid)

proc call*(call_568135: Call_OperationsList_567880; apiVersion: string): Recallable =
  ## operationsList
  ## Exposing Available Operations
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  result = call_568135.call(nil, query_568136, nil, nil, nil)

var operationsList* = Call_OperationsList_567880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.MixedReality/operations",
    validator: validate_OperationsList_567881, base: "", url: url_OperationsList_567882,
    schemes: {Scheme.Https})
type
  Call_CheckNameAvailabilityLocal_568176 = ref object of OpenApiRestCall_567658
proc url_CheckNameAvailabilityLocal_568178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MixedReality/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CheckNameAvailabilityLocal_568177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check Name Availability for global uniqueness
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   location: JString (required)
  ##           : The location in which uniqueness will be verified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568193 = path.getOrDefault("subscriptionId")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "subscriptionId", valid_568193
  var valid_568194 = path.getOrDefault("location")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "location", valid_568194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568195 = query.getOrDefault("api-version")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "api-version", valid_568195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   checkNameAvailability: JObject (required)
  ##                        : Check Name Availability Request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568197: Call_CheckNameAvailabilityLocal_568176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check Name Availability for global uniqueness
  ## 
  let valid = call_568197.validator(path, query, header, formData, body)
  let scheme = call_568197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568197.url(scheme.get, call_568197.host, call_568197.base,
                         call_568197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568197, url, valid)

proc call*(call_568198: Call_CheckNameAvailabilityLocal_568176; apiVersion: string;
          subscriptionId: string; location: string; checkNameAvailability: JsonNode): Recallable =
  ## checkNameAvailabilityLocal
  ## Check Name Availability for global uniqueness
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   location: string (required)
  ##           : The location in which uniqueness will be verified.
  ##   checkNameAvailability: JObject (required)
  ##                        : Check Name Availability Request.
  var path_568199 = newJObject()
  var query_568200 = newJObject()
  var body_568201 = newJObject()
  add(query_568200, "api-version", newJString(apiVersion))
  add(path_568199, "subscriptionId", newJString(subscriptionId))
  add(path_568199, "location", newJString(location))
  if checkNameAvailability != nil:
    body_568201 = checkNameAvailability
  result = call_568198.call(path_568199, query_568200, nil, nil, body_568201)

var checkNameAvailabilityLocal* = Call_CheckNameAvailabilityLocal_568176(
    name: "checkNameAvailabilityLocal", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MixedReality/locations/{location}/checkNameAvailability",
    validator: validate_CheckNameAvailabilityLocal_568177, base: "",
    url: url_CheckNameAvailabilityLocal_568178, schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsListBySubscription_568202 = ref object of OpenApiRestCall_567658
proc url_SpatialAnchorsAccountsListBySubscription_568204(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MixedReality/spatialAnchorsAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpatialAnchorsAccountsListBySubscription_568203(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Spatial Anchors Accounts by Subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568205 = path.getOrDefault("subscriptionId")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "subscriptionId", valid_568205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "api-version", valid_568206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568207: Call_SpatialAnchorsAccountsListBySubscription_568202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Spatial Anchors Accounts by Subscription
  ## 
  let valid = call_568207.validator(path, query, header, formData, body)
  let scheme = call_568207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568207.url(scheme.get, call_568207.host, call_568207.base,
                         call_568207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568207, url, valid)

proc call*(call_568208: Call_SpatialAnchorsAccountsListBySubscription_568202;
          apiVersion: string; subscriptionId: string): Recallable =
  ## spatialAnchorsAccountsListBySubscription
  ## List Spatial Anchors Accounts by Subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_568209 = newJObject()
  var query_568210 = newJObject()
  add(query_568210, "api-version", newJString(apiVersion))
  add(path_568209, "subscriptionId", newJString(subscriptionId))
  result = call_568208.call(path_568209, query_568210, nil, nil, nil)

var spatialAnchorsAccountsListBySubscription* = Call_SpatialAnchorsAccountsListBySubscription_568202(
    name: "spatialAnchorsAccountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MixedReality/spatialAnchorsAccounts",
    validator: validate_SpatialAnchorsAccountsListBySubscription_568203, base: "",
    url: url_SpatialAnchorsAccountsListBySubscription_568204,
    schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsListByResourceGroup_568211 = ref object of OpenApiRestCall_567658
proc url_SpatialAnchorsAccountsListByResourceGroup_568213(protocol: Scheme;
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
        value: "/providers/Microsoft.MixedReality/spatialAnchorsAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpatialAnchorsAccountsListByResourceGroup_568212(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Resources by Resource Group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568214 = path.getOrDefault("resourceGroupName")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "resourceGroupName", valid_568214
  var valid_568215 = path.getOrDefault("subscriptionId")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "subscriptionId", valid_568215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568216 = query.getOrDefault("api-version")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "api-version", valid_568216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568217: Call_SpatialAnchorsAccountsListByResourceGroup_568211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Resources by Resource Group
  ## 
  let valid = call_568217.validator(path, query, header, formData, body)
  let scheme = call_568217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568217.url(scheme.get, call_568217.host, call_568217.base,
                         call_568217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568217, url, valid)

proc call*(call_568218: Call_SpatialAnchorsAccountsListByResourceGroup_568211;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## spatialAnchorsAccountsListByResourceGroup
  ## List Resources by Resource Group
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_568219 = newJObject()
  var query_568220 = newJObject()
  add(path_568219, "resourceGroupName", newJString(resourceGroupName))
  add(query_568220, "api-version", newJString(apiVersion))
  add(path_568219, "subscriptionId", newJString(subscriptionId))
  result = call_568218.call(path_568219, query_568220, nil, nil, nil)

var spatialAnchorsAccountsListByResourceGroup* = Call_SpatialAnchorsAccountsListByResourceGroup_568211(
    name: "spatialAnchorsAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts",
    validator: validate_SpatialAnchorsAccountsListByResourceGroup_568212,
    base: "", url: url_SpatialAnchorsAccountsListByResourceGroup_568213,
    schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsCreate_568232 = ref object of OpenApiRestCall_567658
proc url_SpatialAnchorsAccountsCreate_568234(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "spatialAnchorsAccountName" in path,
        "`spatialAnchorsAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MixedReality/spatialAnchorsAccounts/"),
               (kind: VariableSegment, value: "spatialAnchorsAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpatialAnchorsAccountsCreate_568233(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creating or Updating a Spatial Anchors Account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   spatialAnchorsAccountName: JString (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568235 = path.getOrDefault("resourceGroupName")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "resourceGroupName", valid_568235
  var valid_568236 = path.getOrDefault("subscriptionId")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "subscriptionId", valid_568236
  var valid_568237 = path.getOrDefault("spatialAnchorsAccountName")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "spatialAnchorsAccountName", valid_568237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568238 = query.getOrDefault("api-version")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "api-version", valid_568238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   spatialAnchorsAccount: JObject (required)
  ##                        : Spatial Anchors Account parameter.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568240: Call_SpatialAnchorsAccountsCreate_568232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creating or Updating a Spatial Anchors Account.
  ## 
  let valid = call_568240.validator(path, query, header, formData, body)
  let scheme = call_568240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568240.url(scheme.get, call_568240.host, call_568240.base,
                         call_568240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568240, url, valid)

proc call*(call_568241: Call_SpatialAnchorsAccountsCreate_568232;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          spatialAnchorsAccountName: string; spatialAnchorsAccount: JsonNode): Recallable =
  ## spatialAnchorsAccountsCreate
  ## Creating or Updating a Spatial Anchors Account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   spatialAnchorsAccountName: string (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  ##   spatialAnchorsAccount: JObject (required)
  ##                        : Spatial Anchors Account parameter.
  var path_568242 = newJObject()
  var query_568243 = newJObject()
  var body_568244 = newJObject()
  add(path_568242, "resourceGroupName", newJString(resourceGroupName))
  add(query_568243, "api-version", newJString(apiVersion))
  add(path_568242, "subscriptionId", newJString(subscriptionId))
  add(path_568242, "spatialAnchorsAccountName",
      newJString(spatialAnchorsAccountName))
  if spatialAnchorsAccount != nil:
    body_568244 = spatialAnchorsAccount
  result = call_568241.call(path_568242, query_568243, nil, nil, body_568244)

var spatialAnchorsAccountsCreate* = Call_SpatialAnchorsAccountsCreate_568232(
    name: "spatialAnchorsAccountsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{spatialAnchorsAccountName}",
    validator: validate_SpatialAnchorsAccountsCreate_568233, base: "",
    url: url_SpatialAnchorsAccountsCreate_568234, schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsGet_568221 = ref object of OpenApiRestCall_567658
proc url_SpatialAnchorsAccountsGet_568223(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "spatialAnchorsAccountName" in path,
        "`spatialAnchorsAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MixedReality/spatialAnchorsAccounts/"),
               (kind: VariableSegment, value: "spatialAnchorsAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpatialAnchorsAccountsGet_568222(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a Spatial Anchors Account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   spatialAnchorsAccountName: JString (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568224 = path.getOrDefault("resourceGroupName")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "resourceGroupName", valid_568224
  var valid_568225 = path.getOrDefault("subscriptionId")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "subscriptionId", valid_568225
  var valid_568226 = path.getOrDefault("spatialAnchorsAccountName")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "spatialAnchorsAccountName", valid_568226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568227 = query.getOrDefault("api-version")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "api-version", valid_568227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568228: Call_SpatialAnchorsAccountsGet_568221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a Spatial Anchors Account.
  ## 
  let valid = call_568228.validator(path, query, header, formData, body)
  let scheme = call_568228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568228.url(scheme.get, call_568228.host, call_568228.base,
                         call_568228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568228, url, valid)

proc call*(call_568229: Call_SpatialAnchorsAccountsGet_568221;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          spatialAnchorsAccountName: string): Recallable =
  ## spatialAnchorsAccountsGet
  ## Retrieve a Spatial Anchors Account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   spatialAnchorsAccountName: string (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  var path_568230 = newJObject()
  var query_568231 = newJObject()
  add(path_568230, "resourceGroupName", newJString(resourceGroupName))
  add(query_568231, "api-version", newJString(apiVersion))
  add(path_568230, "subscriptionId", newJString(subscriptionId))
  add(path_568230, "spatialAnchorsAccountName",
      newJString(spatialAnchorsAccountName))
  result = call_568229.call(path_568230, query_568231, nil, nil, nil)

var spatialAnchorsAccountsGet* = Call_SpatialAnchorsAccountsGet_568221(
    name: "spatialAnchorsAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{spatialAnchorsAccountName}",
    validator: validate_SpatialAnchorsAccountsGet_568222, base: "",
    url: url_SpatialAnchorsAccountsGet_568223, schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsUpdate_568256 = ref object of OpenApiRestCall_567658
proc url_SpatialAnchorsAccountsUpdate_568258(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "spatialAnchorsAccountName" in path,
        "`spatialAnchorsAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MixedReality/spatialAnchorsAccounts/"),
               (kind: VariableSegment, value: "spatialAnchorsAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpatialAnchorsAccountsUpdate_568257(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updating a Spatial Anchors Account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   spatialAnchorsAccountName: JString (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568259 = path.getOrDefault("resourceGroupName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "resourceGroupName", valid_568259
  var valid_568260 = path.getOrDefault("subscriptionId")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "subscriptionId", valid_568260
  var valid_568261 = path.getOrDefault("spatialAnchorsAccountName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "spatialAnchorsAccountName", valid_568261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568262 = query.getOrDefault("api-version")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "api-version", valid_568262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   spatialAnchorsAccount: JObject (required)
  ##                        : Spatial Anchors Account parameter.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568264: Call_SpatialAnchorsAccountsUpdate_568256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updating a Spatial Anchors Account
  ## 
  let valid = call_568264.validator(path, query, header, formData, body)
  let scheme = call_568264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568264.url(scheme.get, call_568264.host, call_568264.base,
                         call_568264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568264, url, valid)

proc call*(call_568265: Call_SpatialAnchorsAccountsUpdate_568256;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          spatialAnchorsAccountName: string; spatialAnchorsAccount: JsonNode): Recallable =
  ## spatialAnchorsAccountsUpdate
  ## Updating a Spatial Anchors Account
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   spatialAnchorsAccountName: string (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  ##   spatialAnchorsAccount: JObject (required)
  ##                        : Spatial Anchors Account parameter.
  var path_568266 = newJObject()
  var query_568267 = newJObject()
  var body_568268 = newJObject()
  add(path_568266, "resourceGroupName", newJString(resourceGroupName))
  add(query_568267, "api-version", newJString(apiVersion))
  add(path_568266, "subscriptionId", newJString(subscriptionId))
  add(path_568266, "spatialAnchorsAccountName",
      newJString(spatialAnchorsAccountName))
  if spatialAnchorsAccount != nil:
    body_568268 = spatialAnchorsAccount
  result = call_568265.call(path_568266, query_568267, nil, nil, body_568268)

var spatialAnchorsAccountsUpdate* = Call_SpatialAnchorsAccountsUpdate_568256(
    name: "spatialAnchorsAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{spatialAnchorsAccountName}",
    validator: validate_SpatialAnchorsAccountsUpdate_568257, base: "",
    url: url_SpatialAnchorsAccountsUpdate_568258, schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsDelete_568245 = ref object of OpenApiRestCall_567658
proc url_SpatialAnchorsAccountsDelete_568247(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "spatialAnchorsAccountName" in path,
        "`spatialAnchorsAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MixedReality/spatialAnchorsAccounts/"),
               (kind: VariableSegment, value: "spatialAnchorsAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpatialAnchorsAccountsDelete_568246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Spatial Anchors Account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   spatialAnchorsAccountName: JString (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568248 = path.getOrDefault("resourceGroupName")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "resourceGroupName", valid_568248
  var valid_568249 = path.getOrDefault("subscriptionId")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "subscriptionId", valid_568249
  var valid_568250 = path.getOrDefault("spatialAnchorsAccountName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "spatialAnchorsAccountName", valid_568250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568251 = query.getOrDefault("api-version")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "api-version", valid_568251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568252: Call_SpatialAnchorsAccountsDelete_568245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Spatial Anchors Account.
  ## 
  let valid = call_568252.validator(path, query, header, formData, body)
  let scheme = call_568252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568252.url(scheme.get, call_568252.host, call_568252.base,
                         call_568252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568252, url, valid)

proc call*(call_568253: Call_SpatialAnchorsAccountsDelete_568245;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          spatialAnchorsAccountName: string): Recallable =
  ## spatialAnchorsAccountsDelete
  ## Delete a Spatial Anchors Account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   spatialAnchorsAccountName: string (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  var path_568254 = newJObject()
  var query_568255 = newJObject()
  add(path_568254, "resourceGroupName", newJString(resourceGroupName))
  add(query_568255, "api-version", newJString(apiVersion))
  add(path_568254, "subscriptionId", newJString(subscriptionId))
  add(path_568254, "spatialAnchorsAccountName",
      newJString(spatialAnchorsAccountName))
  result = call_568253.call(path_568254, query_568255, nil, nil, nil)

var spatialAnchorsAccountsDelete* = Call_SpatialAnchorsAccountsDelete_568245(
    name: "spatialAnchorsAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{spatialAnchorsAccountName}",
    validator: validate_SpatialAnchorsAccountsDelete_568246, base: "",
    url: url_SpatialAnchorsAccountsDelete_568247, schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsRegenerateKeys_568280 = ref object of OpenApiRestCall_567658
proc url_SpatialAnchorsAccountsRegenerateKeys_568282(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "spatialAnchorsAccountName" in path,
        "`spatialAnchorsAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MixedReality/spatialAnchorsAccounts/"),
               (kind: VariableSegment, value: "spatialAnchorsAccountName"),
               (kind: ConstantSegment, value: "/keys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpatialAnchorsAccountsRegenerateKeys_568281(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate 1 Key of a Spatial Anchors Account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   spatialAnchorsAccountName: JString (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568283 = path.getOrDefault("resourceGroupName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "resourceGroupName", valid_568283
  var valid_568284 = path.getOrDefault("subscriptionId")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "subscriptionId", valid_568284
  var valid_568285 = path.getOrDefault("spatialAnchorsAccountName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "spatialAnchorsAccountName", valid_568285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568286 = query.getOrDefault("api-version")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "api-version", valid_568286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   spatialAnchorsAccountKeyRegenerate: JObject (required)
  ##                                     : Specifying which key to be regenerated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568288: Call_SpatialAnchorsAccountsRegenerateKeys_568280;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate 1 Key of a Spatial Anchors Account
  ## 
  let valid = call_568288.validator(path, query, header, formData, body)
  let scheme = call_568288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568288.url(scheme.get, call_568288.host, call_568288.base,
                         call_568288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568288, url, valid)

proc call*(call_568289: Call_SpatialAnchorsAccountsRegenerateKeys_568280;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          spatialAnchorsAccountName: string;
          spatialAnchorsAccountKeyRegenerate: JsonNode): Recallable =
  ## spatialAnchorsAccountsRegenerateKeys
  ## Regenerate 1 Key of a Spatial Anchors Account
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   spatialAnchorsAccountName: string (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  ##   spatialAnchorsAccountKeyRegenerate: JObject (required)
  ##                                     : Specifying which key to be regenerated.
  var path_568290 = newJObject()
  var query_568291 = newJObject()
  var body_568292 = newJObject()
  add(path_568290, "resourceGroupName", newJString(resourceGroupName))
  add(query_568291, "api-version", newJString(apiVersion))
  add(path_568290, "subscriptionId", newJString(subscriptionId))
  add(path_568290, "spatialAnchorsAccountName",
      newJString(spatialAnchorsAccountName))
  if spatialAnchorsAccountKeyRegenerate != nil:
    body_568292 = spatialAnchorsAccountKeyRegenerate
  result = call_568289.call(path_568290, query_568291, nil, nil, body_568292)

var spatialAnchorsAccountsRegenerateKeys* = Call_SpatialAnchorsAccountsRegenerateKeys_568280(
    name: "spatialAnchorsAccountsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{spatialAnchorsAccountName}/keys",
    validator: validate_SpatialAnchorsAccountsRegenerateKeys_568281, base: "",
    url: url_SpatialAnchorsAccountsRegenerateKeys_568282, schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsGetKeys_568269 = ref object of OpenApiRestCall_567658
proc url_SpatialAnchorsAccountsGetKeys_568271(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "spatialAnchorsAccountName" in path,
        "`spatialAnchorsAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MixedReality/spatialAnchorsAccounts/"),
               (kind: VariableSegment, value: "spatialAnchorsAccountName"),
               (kind: ConstantSegment, value: "/keys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpatialAnchorsAccountsGetKeys_568270(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Both of the 2 Keys of a Spatial Anchors Account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   spatialAnchorsAccountName: JString (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568272 = path.getOrDefault("resourceGroupName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "resourceGroupName", valid_568272
  var valid_568273 = path.getOrDefault("subscriptionId")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "subscriptionId", valid_568273
  var valid_568274 = path.getOrDefault("spatialAnchorsAccountName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "spatialAnchorsAccountName", valid_568274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568275 = query.getOrDefault("api-version")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "api-version", valid_568275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568276: Call_SpatialAnchorsAccountsGetKeys_568269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Both of the 2 Keys of a Spatial Anchors Account
  ## 
  let valid = call_568276.validator(path, query, header, formData, body)
  let scheme = call_568276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568276.url(scheme.get, call_568276.host, call_568276.base,
                         call_568276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568276, url, valid)

proc call*(call_568277: Call_SpatialAnchorsAccountsGetKeys_568269;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          spatialAnchorsAccountName: string): Recallable =
  ## spatialAnchorsAccountsGetKeys
  ## Get Both of the 2 Keys of a Spatial Anchors Account
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   spatialAnchorsAccountName: string (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  var path_568278 = newJObject()
  var query_568279 = newJObject()
  add(path_568278, "resourceGroupName", newJString(resourceGroupName))
  add(query_568279, "api-version", newJString(apiVersion))
  add(path_568278, "subscriptionId", newJString(subscriptionId))
  add(path_568278, "spatialAnchorsAccountName",
      newJString(spatialAnchorsAccountName))
  result = call_568277.call(path_568278, query_568279, nil, nil, nil)

var spatialAnchorsAccountsGetKeys* = Call_SpatialAnchorsAccountsGetKeys_568269(
    name: "spatialAnchorsAccountsGetKeys", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{spatialAnchorsAccountName}/keys",
    validator: validate_SpatialAnchorsAccountsGetKeys_568270, base: "",
    url: url_SpatialAnchorsAccountsGetKeys_568271, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
