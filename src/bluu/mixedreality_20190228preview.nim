
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  macServiceName = "mixedreality"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563778 = ref object of OpenApiRestCall_563556
proc url_OperationsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563779(path: JsonNode; query: JsonNode;
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

proc call*(call_563964: Call_OperationsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exposing Available Operations
  ## 
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_OperationsList_563778; apiVersion: string): Recallable =
  ## operationsList
  ## Exposing Available Operations
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  result = call_564035.call(nil, query_564036, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.MixedReality/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_CheckNameAvailabilityLocal_564076 = ref object of OpenApiRestCall_563556
proc url_CheckNameAvailabilityLocal_564078(protocol: Scheme; host: string;
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

proc validate_CheckNameAvailabilityLocal_564077(path: JsonNode; query: JsonNode;
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
  var valid_564093 = path.getOrDefault("subscriptionId")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "subscriptionId", valid_564093
  var valid_564094 = path.getOrDefault("location")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "location", valid_564094
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564095 = query.getOrDefault("api-version")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "api-version", valid_564095
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

proc call*(call_564097: Call_CheckNameAvailabilityLocal_564076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check Name Availability for global uniqueness
  ## 
  let valid = call_564097.validator(path, query, header, formData, body)
  let scheme = call_564097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564097.url(scheme.get, call_564097.host, call_564097.base,
                         call_564097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564097, url, valid)

proc call*(call_564098: Call_CheckNameAvailabilityLocal_564076; apiVersion: string;
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
  var path_564099 = newJObject()
  var query_564100 = newJObject()
  var body_564101 = newJObject()
  add(query_564100, "api-version", newJString(apiVersion))
  add(path_564099, "subscriptionId", newJString(subscriptionId))
  add(path_564099, "location", newJString(location))
  if checkNameAvailability != nil:
    body_564101 = checkNameAvailability
  result = call_564098.call(path_564099, query_564100, nil, nil, body_564101)

var checkNameAvailabilityLocal* = Call_CheckNameAvailabilityLocal_564076(
    name: "checkNameAvailabilityLocal", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MixedReality/locations/{location}/checkNameAvailability",
    validator: validate_CheckNameAvailabilityLocal_564077, base: "",
    url: url_CheckNameAvailabilityLocal_564078, schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsListBySubscription_564102 = ref object of OpenApiRestCall_563556
proc url_SpatialAnchorsAccountsListBySubscription_564104(protocol: Scheme;
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

proc validate_SpatialAnchorsAccountsListBySubscription_564103(path: JsonNode;
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
  var valid_564105 = path.getOrDefault("subscriptionId")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "subscriptionId", valid_564105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564106 = query.getOrDefault("api-version")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "api-version", valid_564106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564107: Call_SpatialAnchorsAccountsListBySubscription_564102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Spatial Anchors Accounts by Subscription
  ## 
  let valid = call_564107.validator(path, query, header, formData, body)
  let scheme = call_564107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564107.url(scheme.get, call_564107.host, call_564107.base,
                         call_564107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564107, url, valid)

proc call*(call_564108: Call_SpatialAnchorsAccountsListBySubscription_564102;
          apiVersion: string; subscriptionId: string): Recallable =
  ## spatialAnchorsAccountsListBySubscription
  ## List Spatial Anchors Accounts by Subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_564109 = newJObject()
  var query_564110 = newJObject()
  add(query_564110, "api-version", newJString(apiVersion))
  add(path_564109, "subscriptionId", newJString(subscriptionId))
  result = call_564108.call(path_564109, query_564110, nil, nil, nil)

var spatialAnchorsAccountsListBySubscription* = Call_SpatialAnchorsAccountsListBySubscription_564102(
    name: "spatialAnchorsAccountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MixedReality/spatialAnchorsAccounts",
    validator: validate_SpatialAnchorsAccountsListBySubscription_564103, base: "",
    url: url_SpatialAnchorsAccountsListBySubscription_564104,
    schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsListByResourceGroup_564111 = ref object of OpenApiRestCall_563556
proc url_SpatialAnchorsAccountsListByResourceGroup_564113(protocol: Scheme;
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

proc validate_SpatialAnchorsAccountsListByResourceGroup_564112(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Resources by Resource Group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564114 = path.getOrDefault("subscriptionId")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "subscriptionId", valid_564114
  var valid_564115 = path.getOrDefault("resourceGroupName")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "resourceGroupName", valid_564115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564116 = query.getOrDefault("api-version")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "api-version", valid_564116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564117: Call_SpatialAnchorsAccountsListByResourceGroup_564111;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Resources by Resource Group
  ## 
  let valid = call_564117.validator(path, query, header, formData, body)
  let scheme = call_564117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564117.url(scheme.get, call_564117.host, call_564117.base,
                         call_564117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564117, url, valid)

proc call*(call_564118: Call_SpatialAnchorsAccountsListByResourceGroup_564111;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## spatialAnchorsAccountsListByResourceGroup
  ## List Resources by Resource Group
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  var path_564119 = newJObject()
  var query_564120 = newJObject()
  add(query_564120, "api-version", newJString(apiVersion))
  add(path_564119, "subscriptionId", newJString(subscriptionId))
  add(path_564119, "resourceGroupName", newJString(resourceGroupName))
  result = call_564118.call(path_564119, query_564120, nil, nil, nil)

var spatialAnchorsAccountsListByResourceGroup* = Call_SpatialAnchorsAccountsListByResourceGroup_564111(
    name: "spatialAnchorsAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts",
    validator: validate_SpatialAnchorsAccountsListByResourceGroup_564112,
    base: "", url: url_SpatialAnchorsAccountsListByResourceGroup_564113,
    schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsCreate_564132 = ref object of OpenApiRestCall_563556
proc url_SpatialAnchorsAccountsCreate_564134(protocol: Scheme; host: string;
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

proc validate_SpatialAnchorsAccountsCreate_564133(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creating or Updating a Spatial Anchors Account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spatialAnchorsAccountName: JString (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `spatialAnchorsAccountName` field"
  var valid_564135 = path.getOrDefault("spatialAnchorsAccountName")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "spatialAnchorsAccountName", valid_564135
  var valid_564136 = path.getOrDefault("subscriptionId")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "subscriptionId", valid_564136
  var valid_564137 = path.getOrDefault("resourceGroupName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "resourceGroupName", valid_564137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564138 = query.getOrDefault("api-version")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "api-version", valid_564138
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

proc call*(call_564140: Call_SpatialAnchorsAccountsCreate_564132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creating or Updating a Spatial Anchors Account.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_SpatialAnchorsAccountsCreate_564132;
          apiVersion: string; spatialAnchorsAccountName: string;
          subscriptionId: string; resourceGroupName: string;
          spatialAnchorsAccount: JsonNode): Recallable =
  ## spatialAnchorsAccountsCreate
  ## Creating or Updating a Spatial Anchors Account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   spatialAnchorsAccountName: string (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   spatialAnchorsAccount: JObject (required)
  ##                        : Spatial Anchors Account parameter.
  var path_564142 = newJObject()
  var query_564143 = newJObject()
  var body_564144 = newJObject()
  add(query_564143, "api-version", newJString(apiVersion))
  add(path_564142, "spatialAnchorsAccountName",
      newJString(spatialAnchorsAccountName))
  add(path_564142, "subscriptionId", newJString(subscriptionId))
  add(path_564142, "resourceGroupName", newJString(resourceGroupName))
  if spatialAnchorsAccount != nil:
    body_564144 = spatialAnchorsAccount
  result = call_564141.call(path_564142, query_564143, nil, nil, body_564144)

var spatialAnchorsAccountsCreate* = Call_SpatialAnchorsAccountsCreate_564132(
    name: "spatialAnchorsAccountsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{spatialAnchorsAccountName}",
    validator: validate_SpatialAnchorsAccountsCreate_564133, base: "",
    url: url_SpatialAnchorsAccountsCreate_564134, schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsGet_564121 = ref object of OpenApiRestCall_563556
proc url_SpatialAnchorsAccountsGet_564123(protocol: Scheme; host: string;
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

proc validate_SpatialAnchorsAccountsGet_564122(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a Spatial Anchors Account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spatialAnchorsAccountName: JString (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `spatialAnchorsAccountName` field"
  var valid_564124 = path.getOrDefault("spatialAnchorsAccountName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "spatialAnchorsAccountName", valid_564124
  var valid_564125 = path.getOrDefault("subscriptionId")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "subscriptionId", valid_564125
  var valid_564126 = path.getOrDefault("resourceGroupName")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "resourceGroupName", valid_564126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564127 = query.getOrDefault("api-version")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "api-version", valid_564127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564128: Call_SpatialAnchorsAccountsGet_564121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a Spatial Anchors Account.
  ## 
  let valid = call_564128.validator(path, query, header, formData, body)
  let scheme = call_564128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564128.url(scheme.get, call_564128.host, call_564128.base,
                         call_564128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564128, url, valid)

proc call*(call_564129: Call_SpatialAnchorsAccountsGet_564121; apiVersion: string;
          spatialAnchorsAccountName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## spatialAnchorsAccountsGet
  ## Retrieve a Spatial Anchors Account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   spatialAnchorsAccountName: string (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  var path_564130 = newJObject()
  var query_564131 = newJObject()
  add(query_564131, "api-version", newJString(apiVersion))
  add(path_564130, "spatialAnchorsAccountName",
      newJString(spatialAnchorsAccountName))
  add(path_564130, "subscriptionId", newJString(subscriptionId))
  add(path_564130, "resourceGroupName", newJString(resourceGroupName))
  result = call_564129.call(path_564130, query_564131, nil, nil, nil)

var spatialAnchorsAccountsGet* = Call_SpatialAnchorsAccountsGet_564121(
    name: "spatialAnchorsAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{spatialAnchorsAccountName}",
    validator: validate_SpatialAnchorsAccountsGet_564122, base: "",
    url: url_SpatialAnchorsAccountsGet_564123, schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsUpdate_564156 = ref object of OpenApiRestCall_563556
proc url_SpatialAnchorsAccountsUpdate_564158(protocol: Scheme; host: string;
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

proc validate_SpatialAnchorsAccountsUpdate_564157(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updating a Spatial Anchors Account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spatialAnchorsAccountName: JString (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `spatialAnchorsAccountName` field"
  var valid_564159 = path.getOrDefault("spatialAnchorsAccountName")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "spatialAnchorsAccountName", valid_564159
  var valid_564160 = path.getOrDefault("subscriptionId")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "subscriptionId", valid_564160
  var valid_564161 = path.getOrDefault("resourceGroupName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "resourceGroupName", valid_564161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564162 = query.getOrDefault("api-version")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "api-version", valid_564162
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

proc call*(call_564164: Call_SpatialAnchorsAccountsUpdate_564156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updating a Spatial Anchors Account
  ## 
  let valid = call_564164.validator(path, query, header, formData, body)
  let scheme = call_564164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564164.url(scheme.get, call_564164.host, call_564164.base,
                         call_564164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564164, url, valid)

proc call*(call_564165: Call_SpatialAnchorsAccountsUpdate_564156;
          apiVersion: string; spatialAnchorsAccountName: string;
          subscriptionId: string; resourceGroupName: string;
          spatialAnchorsAccount: JsonNode): Recallable =
  ## spatialAnchorsAccountsUpdate
  ## Updating a Spatial Anchors Account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   spatialAnchorsAccountName: string (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   spatialAnchorsAccount: JObject (required)
  ##                        : Spatial Anchors Account parameter.
  var path_564166 = newJObject()
  var query_564167 = newJObject()
  var body_564168 = newJObject()
  add(query_564167, "api-version", newJString(apiVersion))
  add(path_564166, "spatialAnchorsAccountName",
      newJString(spatialAnchorsAccountName))
  add(path_564166, "subscriptionId", newJString(subscriptionId))
  add(path_564166, "resourceGroupName", newJString(resourceGroupName))
  if spatialAnchorsAccount != nil:
    body_564168 = spatialAnchorsAccount
  result = call_564165.call(path_564166, query_564167, nil, nil, body_564168)

var spatialAnchorsAccountsUpdate* = Call_SpatialAnchorsAccountsUpdate_564156(
    name: "spatialAnchorsAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{spatialAnchorsAccountName}",
    validator: validate_SpatialAnchorsAccountsUpdate_564157, base: "",
    url: url_SpatialAnchorsAccountsUpdate_564158, schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsDelete_564145 = ref object of OpenApiRestCall_563556
proc url_SpatialAnchorsAccountsDelete_564147(protocol: Scheme; host: string;
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

proc validate_SpatialAnchorsAccountsDelete_564146(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Spatial Anchors Account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spatialAnchorsAccountName: JString (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `spatialAnchorsAccountName` field"
  var valid_564148 = path.getOrDefault("spatialAnchorsAccountName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "spatialAnchorsAccountName", valid_564148
  var valid_564149 = path.getOrDefault("subscriptionId")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "subscriptionId", valid_564149
  var valid_564150 = path.getOrDefault("resourceGroupName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "resourceGroupName", valid_564150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564151 = query.getOrDefault("api-version")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "api-version", valid_564151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564152: Call_SpatialAnchorsAccountsDelete_564145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Spatial Anchors Account.
  ## 
  let valid = call_564152.validator(path, query, header, formData, body)
  let scheme = call_564152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564152.url(scheme.get, call_564152.host, call_564152.base,
                         call_564152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564152, url, valid)

proc call*(call_564153: Call_SpatialAnchorsAccountsDelete_564145;
          apiVersion: string; spatialAnchorsAccountName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## spatialAnchorsAccountsDelete
  ## Delete a Spatial Anchors Account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   spatialAnchorsAccountName: string (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  var path_564154 = newJObject()
  var query_564155 = newJObject()
  add(query_564155, "api-version", newJString(apiVersion))
  add(path_564154, "spatialAnchorsAccountName",
      newJString(spatialAnchorsAccountName))
  add(path_564154, "subscriptionId", newJString(subscriptionId))
  add(path_564154, "resourceGroupName", newJString(resourceGroupName))
  result = call_564153.call(path_564154, query_564155, nil, nil, nil)

var spatialAnchorsAccountsDelete* = Call_SpatialAnchorsAccountsDelete_564145(
    name: "spatialAnchorsAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{spatialAnchorsAccountName}",
    validator: validate_SpatialAnchorsAccountsDelete_564146, base: "",
    url: url_SpatialAnchorsAccountsDelete_564147, schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsRegenerateKeys_564180 = ref object of OpenApiRestCall_563556
proc url_SpatialAnchorsAccountsRegenerateKeys_564182(protocol: Scheme;
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

proc validate_SpatialAnchorsAccountsRegenerateKeys_564181(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate 1 Key of a Spatial Anchors Account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spatialAnchorsAccountName: JString (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `spatialAnchorsAccountName` field"
  var valid_564183 = path.getOrDefault("spatialAnchorsAccountName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "spatialAnchorsAccountName", valid_564183
  var valid_564184 = path.getOrDefault("subscriptionId")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "subscriptionId", valid_564184
  var valid_564185 = path.getOrDefault("resourceGroupName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "resourceGroupName", valid_564185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564186 = query.getOrDefault("api-version")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "api-version", valid_564186
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

proc call*(call_564188: Call_SpatialAnchorsAccountsRegenerateKeys_564180;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate 1 Key of a Spatial Anchors Account
  ## 
  let valid = call_564188.validator(path, query, header, formData, body)
  let scheme = call_564188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564188.url(scheme.get, call_564188.host, call_564188.base,
                         call_564188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564188, url, valid)

proc call*(call_564189: Call_SpatialAnchorsAccountsRegenerateKeys_564180;
          apiVersion: string; spatialAnchorsAccountName: string;
          spatialAnchorsAccountKeyRegenerate: JsonNode; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## spatialAnchorsAccountsRegenerateKeys
  ## Regenerate 1 Key of a Spatial Anchors Account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   spatialAnchorsAccountName: string (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  ##   spatialAnchorsAccountKeyRegenerate: JObject (required)
  ##                                     : Specifying which key to be regenerated.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  var path_564190 = newJObject()
  var query_564191 = newJObject()
  var body_564192 = newJObject()
  add(query_564191, "api-version", newJString(apiVersion))
  add(path_564190, "spatialAnchorsAccountName",
      newJString(spatialAnchorsAccountName))
  if spatialAnchorsAccountKeyRegenerate != nil:
    body_564192 = spatialAnchorsAccountKeyRegenerate
  add(path_564190, "subscriptionId", newJString(subscriptionId))
  add(path_564190, "resourceGroupName", newJString(resourceGroupName))
  result = call_564189.call(path_564190, query_564191, nil, nil, body_564192)

var spatialAnchorsAccountsRegenerateKeys* = Call_SpatialAnchorsAccountsRegenerateKeys_564180(
    name: "spatialAnchorsAccountsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{spatialAnchorsAccountName}/keys",
    validator: validate_SpatialAnchorsAccountsRegenerateKeys_564181, base: "",
    url: url_SpatialAnchorsAccountsRegenerateKeys_564182, schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsGetKeys_564169 = ref object of OpenApiRestCall_563556
proc url_SpatialAnchorsAccountsGetKeys_564171(protocol: Scheme; host: string;
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

proc validate_SpatialAnchorsAccountsGetKeys_564170(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Both of the 2 Keys of a Spatial Anchors Account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spatialAnchorsAccountName: JString (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `spatialAnchorsAccountName` field"
  var valid_564172 = path.getOrDefault("spatialAnchorsAccountName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "spatialAnchorsAccountName", valid_564172
  var valid_564173 = path.getOrDefault("subscriptionId")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "subscriptionId", valid_564173
  var valid_564174 = path.getOrDefault("resourceGroupName")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "resourceGroupName", valid_564174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564175 = query.getOrDefault("api-version")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "api-version", valid_564175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564176: Call_SpatialAnchorsAccountsGetKeys_564169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Both of the 2 Keys of a Spatial Anchors Account
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_SpatialAnchorsAccountsGetKeys_564169;
          apiVersion: string; spatialAnchorsAccountName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## spatialAnchorsAccountsGetKeys
  ## Get Both of the 2 Keys of a Spatial Anchors Account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   spatialAnchorsAccountName: string (required)
  ##                            : Name of an Mixed Reality Spatial Anchors Account.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  var path_564178 = newJObject()
  var query_564179 = newJObject()
  add(query_564179, "api-version", newJString(apiVersion))
  add(path_564178, "spatialAnchorsAccountName",
      newJString(spatialAnchorsAccountName))
  add(path_564178, "subscriptionId", newJString(subscriptionId))
  add(path_564178, "resourceGroupName", newJString(resourceGroupName))
  result = call_564177.call(path_564178, query_564179, nil, nil, nil)

var spatialAnchorsAccountsGetKeys* = Call_SpatialAnchorsAccountsGetKeys_564169(
    name: "spatialAnchorsAccountsGetKeys", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{spatialAnchorsAccountName}/keys",
    validator: validate_SpatialAnchorsAccountsGetKeys_564170, base: "",
    url: url_SpatialAnchorsAccountsGetKeys_564171, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
