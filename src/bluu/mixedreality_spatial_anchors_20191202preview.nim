
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Mixed Reality
## version: 2019-12-02-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Mixed Reality Resource Provider Spatial Anchors Resource API
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "mixedreality-spatial-anchors"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SpatialAnchorsAccountsListBySubscription_567879 = ref object of OpenApiRestCall_567657
proc url_SpatialAnchorsAccountsListBySubscription_567881(protocol: Scheme;
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

proc validate_SpatialAnchorsAccountsListBySubscription_567880(path: JsonNode;
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
  var valid_568041 = path.getOrDefault("subscriptionId")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "subscriptionId", valid_568041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568042 = query.getOrDefault("api-version")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "api-version", valid_568042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568069: Call_SpatialAnchorsAccountsListBySubscription_567879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Spatial Anchors Accounts by Subscription
  ## 
  let valid = call_568069.validator(path, query, header, formData, body)
  let scheme = call_568069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568069.url(scheme.get, call_568069.host, call_568069.base,
                         call_568069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568069, url, valid)

proc call*(call_568140: Call_SpatialAnchorsAccountsListBySubscription_567879;
          apiVersion: string; subscriptionId: string): Recallable =
  ## spatialAnchorsAccountsListBySubscription
  ## List Spatial Anchors Accounts by Subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_568141 = newJObject()
  var query_568143 = newJObject()
  add(query_568143, "api-version", newJString(apiVersion))
  add(path_568141, "subscriptionId", newJString(subscriptionId))
  result = call_568140.call(path_568141, query_568143, nil, nil, nil)

var spatialAnchorsAccountsListBySubscription* = Call_SpatialAnchorsAccountsListBySubscription_567879(
    name: "spatialAnchorsAccountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MixedReality/spatialAnchorsAccounts",
    validator: validate_SpatialAnchorsAccountsListBySubscription_567880, base: "",
    url: url_SpatialAnchorsAccountsListBySubscription_567881,
    schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsListByResourceGroup_568182 = ref object of OpenApiRestCall_567657
proc url_SpatialAnchorsAccountsListByResourceGroup_568184(protocol: Scheme;
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

proc validate_SpatialAnchorsAccountsListByResourceGroup_568183(path: JsonNode;
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
  var valid_568185 = path.getOrDefault("resourceGroupName")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "resourceGroupName", valid_568185
  var valid_568186 = path.getOrDefault("subscriptionId")
  valid_568186 = validateParameter(valid_568186, JString, required = true,
                                 default = nil)
  if valid_568186 != nil:
    section.add "subscriptionId", valid_568186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568187 = query.getOrDefault("api-version")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "api-version", valid_568187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568188: Call_SpatialAnchorsAccountsListByResourceGroup_568182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Resources by Resource Group
  ## 
  let valid = call_568188.validator(path, query, header, formData, body)
  let scheme = call_568188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568188.url(scheme.get, call_568188.host, call_568188.base,
                         call_568188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568188, url, valid)

proc call*(call_568189: Call_SpatialAnchorsAccountsListByResourceGroup_568182;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## spatialAnchorsAccountsListByResourceGroup
  ## List Resources by Resource Group
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_568190 = newJObject()
  var query_568191 = newJObject()
  add(path_568190, "resourceGroupName", newJString(resourceGroupName))
  add(query_568191, "api-version", newJString(apiVersion))
  add(path_568190, "subscriptionId", newJString(subscriptionId))
  result = call_568189.call(path_568190, query_568191, nil, nil, nil)

var spatialAnchorsAccountsListByResourceGroup* = Call_SpatialAnchorsAccountsListByResourceGroup_568182(
    name: "spatialAnchorsAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts",
    validator: validate_SpatialAnchorsAccountsListByResourceGroup_568183,
    base: "", url: url_SpatialAnchorsAccountsListByResourceGroup_568184,
    schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsCreate_568203 = ref object of OpenApiRestCall_567657
proc url_SpatialAnchorsAccountsCreate_568205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MixedReality/spatialAnchorsAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpatialAnchorsAccountsCreate_568204(path: JsonNode; query: JsonNode;
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
  ##   accountName: JString (required)
  ##              : Name of an Mixed Reality Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568215 = path.getOrDefault("resourceGroupName")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "resourceGroupName", valid_568215
  var valid_568216 = path.getOrDefault("subscriptionId")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "subscriptionId", valid_568216
  var valid_568217 = path.getOrDefault("accountName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "accountName", valid_568217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568218 = query.getOrDefault("api-version")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "api-version", valid_568218
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

proc call*(call_568220: Call_SpatialAnchorsAccountsCreate_568203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creating or Updating a Spatial Anchors Account.
  ## 
  let valid = call_568220.validator(path, query, header, formData, body)
  let scheme = call_568220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568220.url(scheme.get, call_568220.host, call_568220.base,
                         call_568220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568220, url, valid)

proc call*(call_568221: Call_SpatialAnchorsAccountsCreate_568203;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          spatialAnchorsAccount: JsonNode; accountName: string): Recallable =
  ## spatialAnchorsAccountsCreate
  ## Creating or Updating a Spatial Anchors Account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   spatialAnchorsAccount: JObject (required)
  ##                        : Spatial Anchors Account parameter.
  ##   accountName: string (required)
  ##              : Name of an Mixed Reality Account.
  var path_568222 = newJObject()
  var query_568223 = newJObject()
  var body_568224 = newJObject()
  add(path_568222, "resourceGroupName", newJString(resourceGroupName))
  add(query_568223, "api-version", newJString(apiVersion))
  add(path_568222, "subscriptionId", newJString(subscriptionId))
  if spatialAnchorsAccount != nil:
    body_568224 = spatialAnchorsAccount
  add(path_568222, "accountName", newJString(accountName))
  result = call_568221.call(path_568222, query_568223, nil, nil, body_568224)

var spatialAnchorsAccountsCreate* = Call_SpatialAnchorsAccountsCreate_568203(
    name: "spatialAnchorsAccountsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{accountName}",
    validator: validate_SpatialAnchorsAccountsCreate_568204, base: "",
    url: url_SpatialAnchorsAccountsCreate_568205, schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsGet_568192 = ref object of OpenApiRestCall_567657
proc url_SpatialAnchorsAccountsGet_568194(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MixedReality/spatialAnchorsAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpatialAnchorsAccountsGet_568193(path: JsonNode; query: JsonNode;
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
  ##   accountName: JString (required)
  ##              : Name of an Mixed Reality Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568195 = path.getOrDefault("resourceGroupName")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "resourceGroupName", valid_568195
  var valid_568196 = path.getOrDefault("subscriptionId")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "subscriptionId", valid_568196
  var valid_568197 = path.getOrDefault("accountName")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "accountName", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568199: Call_SpatialAnchorsAccountsGet_568192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a Spatial Anchors Account.
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_SpatialAnchorsAccountsGet_568192;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## spatialAnchorsAccountsGet
  ## Retrieve a Spatial Anchors Account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Name of an Mixed Reality Account.
  var path_568201 = newJObject()
  var query_568202 = newJObject()
  add(path_568201, "resourceGroupName", newJString(resourceGroupName))
  add(query_568202, "api-version", newJString(apiVersion))
  add(path_568201, "subscriptionId", newJString(subscriptionId))
  add(path_568201, "accountName", newJString(accountName))
  result = call_568200.call(path_568201, query_568202, nil, nil, nil)

var spatialAnchorsAccountsGet* = Call_SpatialAnchorsAccountsGet_568192(
    name: "spatialAnchorsAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{accountName}",
    validator: validate_SpatialAnchorsAccountsGet_568193, base: "",
    url: url_SpatialAnchorsAccountsGet_568194, schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsUpdate_568236 = ref object of OpenApiRestCall_567657
proc url_SpatialAnchorsAccountsUpdate_568238(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MixedReality/spatialAnchorsAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpatialAnchorsAccountsUpdate_568237(path: JsonNode; query: JsonNode;
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
  ##   accountName: JString (required)
  ##              : Name of an Mixed Reality Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568239 = path.getOrDefault("resourceGroupName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "resourceGroupName", valid_568239
  var valid_568240 = path.getOrDefault("subscriptionId")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "subscriptionId", valid_568240
  var valid_568241 = path.getOrDefault("accountName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "accountName", valid_568241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568242 = query.getOrDefault("api-version")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "api-version", valid_568242
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

proc call*(call_568244: Call_SpatialAnchorsAccountsUpdate_568236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updating a Spatial Anchors Account
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_SpatialAnchorsAccountsUpdate_568236;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          spatialAnchorsAccount: JsonNode; accountName: string): Recallable =
  ## spatialAnchorsAccountsUpdate
  ## Updating a Spatial Anchors Account
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   spatialAnchorsAccount: JObject (required)
  ##                        : Spatial Anchors Account parameter.
  ##   accountName: string (required)
  ##              : Name of an Mixed Reality Account.
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  var body_568248 = newJObject()
  add(path_568246, "resourceGroupName", newJString(resourceGroupName))
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  if spatialAnchorsAccount != nil:
    body_568248 = spatialAnchorsAccount
  add(path_568246, "accountName", newJString(accountName))
  result = call_568245.call(path_568246, query_568247, nil, nil, body_568248)

var spatialAnchorsAccountsUpdate* = Call_SpatialAnchorsAccountsUpdate_568236(
    name: "spatialAnchorsAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{accountName}",
    validator: validate_SpatialAnchorsAccountsUpdate_568237, base: "",
    url: url_SpatialAnchorsAccountsUpdate_568238, schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsDelete_568225 = ref object of OpenApiRestCall_567657
proc url_SpatialAnchorsAccountsDelete_568227(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MixedReality/spatialAnchorsAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpatialAnchorsAccountsDelete_568226(path: JsonNode; query: JsonNode;
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
  ##   accountName: JString (required)
  ##              : Name of an Mixed Reality Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568228 = path.getOrDefault("resourceGroupName")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "resourceGroupName", valid_568228
  var valid_568229 = path.getOrDefault("subscriptionId")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "subscriptionId", valid_568229
  var valid_568230 = path.getOrDefault("accountName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "accountName", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568231 = query.getOrDefault("api-version")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "api-version", valid_568231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568232: Call_SpatialAnchorsAccountsDelete_568225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Spatial Anchors Account.
  ## 
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_SpatialAnchorsAccountsDelete_568225;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## spatialAnchorsAccountsDelete
  ## Delete a Spatial Anchors Account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Name of an Mixed Reality Account.
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  add(path_568234, "resourceGroupName", newJString(resourceGroupName))
  add(query_568235, "api-version", newJString(apiVersion))
  add(path_568234, "subscriptionId", newJString(subscriptionId))
  add(path_568234, "accountName", newJString(accountName))
  result = call_568233.call(path_568234, query_568235, nil, nil, nil)

var spatialAnchorsAccountsDelete* = Call_SpatialAnchorsAccountsDelete_568225(
    name: "spatialAnchorsAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{accountName}",
    validator: validate_SpatialAnchorsAccountsDelete_568226, base: "",
    url: url_SpatialAnchorsAccountsDelete_568227, schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsRegenerateKeys_568260 = ref object of OpenApiRestCall_567657
proc url_SpatialAnchorsAccountsRegenerateKeys_568262(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MixedReality/spatialAnchorsAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/keys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpatialAnchorsAccountsRegenerateKeys_568261(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate specified Key of a Spatial Anchors Account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Name of an Mixed Reality Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568263 = path.getOrDefault("resourceGroupName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "resourceGroupName", valid_568263
  var valid_568264 = path.getOrDefault("subscriptionId")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "subscriptionId", valid_568264
  var valid_568265 = path.getOrDefault("accountName")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "accountName", valid_568265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568266 = query.getOrDefault("api-version")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "api-version", valid_568266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regenerate: JObject (required)
  ##             : Required information for key regeneration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568268: Call_SpatialAnchorsAccountsRegenerateKeys_568260;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate specified Key of a Spatial Anchors Account
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_SpatialAnchorsAccountsRegenerateKeys_568260;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          regenerate: JsonNode; accountName: string): Recallable =
  ## spatialAnchorsAccountsRegenerateKeys
  ## Regenerate specified Key of a Spatial Anchors Account
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   regenerate: JObject (required)
  ##             : Required information for key regeneration.
  ##   accountName: string (required)
  ##              : Name of an Mixed Reality Account.
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  var body_568272 = newJObject()
  add(path_568270, "resourceGroupName", newJString(resourceGroupName))
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "subscriptionId", newJString(subscriptionId))
  if regenerate != nil:
    body_568272 = regenerate
  add(path_568270, "accountName", newJString(accountName))
  result = call_568269.call(path_568270, query_568271, nil, nil, body_568272)

var spatialAnchorsAccountsRegenerateKeys* = Call_SpatialAnchorsAccountsRegenerateKeys_568260(
    name: "spatialAnchorsAccountsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{accountName}/keys",
    validator: validate_SpatialAnchorsAccountsRegenerateKeys_568261, base: "",
    url: url_SpatialAnchorsAccountsRegenerateKeys_568262, schemes: {Scheme.Https})
type
  Call_SpatialAnchorsAccountsGetKeys_568249 = ref object of OpenApiRestCall_567657
proc url_SpatialAnchorsAccountsGetKeys_568251(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MixedReality/spatialAnchorsAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/keys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpatialAnchorsAccountsGetKeys_568250(path: JsonNode; query: JsonNode;
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
  ##   accountName: JString (required)
  ##              : Name of an Mixed Reality Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568252 = path.getOrDefault("resourceGroupName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "resourceGroupName", valid_568252
  var valid_568253 = path.getOrDefault("subscriptionId")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "subscriptionId", valid_568253
  var valid_568254 = path.getOrDefault("accountName")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "accountName", valid_568254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568255 = query.getOrDefault("api-version")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "api-version", valid_568255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568256: Call_SpatialAnchorsAccountsGetKeys_568249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Both of the 2 Keys of a Spatial Anchors Account
  ## 
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_SpatialAnchorsAccountsGetKeys_568249;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## spatialAnchorsAccountsGetKeys
  ## Get Both of the 2 Keys of a Spatial Anchors Account
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Name of an Mixed Reality Account.
  var path_568258 = newJObject()
  var query_568259 = newJObject()
  add(path_568258, "resourceGroupName", newJString(resourceGroupName))
  add(query_568259, "api-version", newJString(apiVersion))
  add(path_568258, "subscriptionId", newJString(subscriptionId))
  add(path_568258, "accountName", newJString(accountName))
  result = call_568257.call(path_568258, query_568259, nil, nil, nil)

var spatialAnchorsAccountsGetKeys* = Call_SpatialAnchorsAccountsGetKeys_568249(
    name: "spatialAnchorsAccountsGetKeys", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/spatialAnchorsAccounts/{accountName}/keys",
    validator: validate_SpatialAnchorsAccountsGetKeys_568250, base: "",
    url: url_SpatialAnchorsAccountsGetKeys_568251, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
