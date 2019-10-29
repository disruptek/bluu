
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: StorageManagementClient
## version: 2015-12-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Admin Storage Management Client.
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
  macServiceName = "azsadmin-farms"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FarmsList_563778 = ref object of OpenApiRestCall_563556
proc url_FarmsList_563780(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FarmsList_563779(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of all storage farms.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563942 = path.getOrDefault("subscriptionId")
  valid_563942 = validateParameter(valid_563942, JString, required = true,
                                 default = nil)
  if valid_563942 != nil:
    section.add "subscriptionId", valid_563942
  var valid_563943 = path.getOrDefault("resourceGroupName")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "resourceGroupName", valid_563943
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563944 = query.getOrDefault("api-version")
  valid_563944 = validateParameter(valid_563944, JString, required = true,
                                 default = nil)
  if valid_563944 != nil:
    section.add "api-version", valid_563944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563971: Call_FarmsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all storage farms.
  ## 
  let valid = call_563971.validator(path, query, header, formData, body)
  let scheme = call_563971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563971.url(scheme.get, call_563971.host, call_563971.base,
                         call_563971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563971, url, valid)

proc call*(call_564042: Call_FarmsList_563778; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## farmsList
  ## Returns a list of all storage farms.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  var path_564043 = newJObject()
  var query_564045 = newJObject()
  add(query_564045, "api-version", newJString(apiVersion))
  add(path_564043, "subscriptionId", newJString(subscriptionId))
  add(path_564043, "resourceGroupName", newJString(resourceGroupName))
  result = call_564042.call(path_564043, query_564045, nil, nil, nil)

var farmsList* = Call_FarmsList_563778(name: "farmsList", meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms",
                                    validator: validate_FarmsList_563779,
                                    base: "", url: url_FarmsList_563780,
                                    schemes: {Scheme.Https})
type
  Call_FarmsCreate_564095 = ref object of OpenApiRestCall_563556
proc url_FarmsCreate_564097(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FarmsCreate_564096(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new storage farm.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `farmId` field"
  var valid_564107 = path.getOrDefault("farmId")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "farmId", valid_564107
  var valid_564108 = path.getOrDefault("subscriptionId")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "subscriptionId", valid_564108
  var valid_564109 = path.getOrDefault("resourceGroupName")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "resourceGroupName", valid_564109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564110 = query.getOrDefault("api-version")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "api-version", valid_564110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   farmObject: JObject (required)
  ##             : Parameters used to create a farm
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564112: Call_FarmsCreate_564095; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new storage farm.
  ## 
  let valid = call_564112.validator(path, query, header, formData, body)
  let scheme = call_564112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564112.url(scheme.get, call_564112.host, call_564112.base,
                         call_564112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564112, url, valid)

proc call*(call_564113: Call_FarmsCreate_564095; farmObject: JsonNode;
          apiVersion: string; farmId: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## farmsCreate
  ## Create a new storage farm.
  ##   farmObject: JObject (required)
  ##             : Parameters used to create a farm
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  var path_564114 = newJObject()
  var query_564115 = newJObject()
  var body_564116 = newJObject()
  if farmObject != nil:
    body_564116 = farmObject
  add(query_564115, "api-version", newJString(apiVersion))
  add(path_564114, "farmId", newJString(farmId))
  add(path_564114, "subscriptionId", newJString(subscriptionId))
  add(path_564114, "resourceGroupName", newJString(resourceGroupName))
  result = call_564113.call(path_564114, query_564115, nil, nil, body_564116)

var farmsCreate* = Call_FarmsCreate_564095(name: "farmsCreate",
                                        meth: HttpMethod.HttpPut, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}",
                                        validator: validate_FarmsCreate_564096,
                                        base: "", url: url_FarmsCreate_564097,
                                        schemes: {Scheme.Https})
type
  Call_FarmsGet_564084 = ref object of OpenApiRestCall_563556
proc url_FarmsGet_564086(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FarmsGet_564085(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the Storage properties and settings for a specified storage farm.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `farmId` field"
  var valid_564087 = path.getOrDefault("farmId")
  valid_564087 = validateParameter(valid_564087, JString, required = true,
                                 default = nil)
  if valid_564087 != nil:
    section.add "farmId", valid_564087
  var valid_564088 = path.getOrDefault("subscriptionId")
  valid_564088 = validateParameter(valid_564088, JString, required = true,
                                 default = nil)
  if valid_564088 != nil:
    section.add "subscriptionId", valid_564088
  var valid_564089 = path.getOrDefault("resourceGroupName")
  valid_564089 = validateParameter(valid_564089, JString, required = true,
                                 default = nil)
  if valid_564089 != nil:
    section.add "resourceGroupName", valid_564089
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564090 = query.getOrDefault("api-version")
  valid_564090 = validateParameter(valid_564090, JString, required = true,
                                 default = nil)
  if valid_564090 != nil:
    section.add "api-version", valid_564090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564091: Call_FarmsGet_564084; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the Storage properties and settings for a specified storage farm.
  ## 
  let valid = call_564091.validator(path, query, header, formData, body)
  let scheme = call_564091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564091.url(scheme.get, call_564091.host, call_564091.base,
                         call_564091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564091, url, valid)

proc call*(call_564092: Call_FarmsGet_564084; apiVersion: string; farmId: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## farmsGet
  ## Returns the Storage properties and settings for a specified storage farm.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  var path_564093 = newJObject()
  var query_564094 = newJObject()
  add(query_564094, "api-version", newJString(apiVersion))
  add(path_564093, "farmId", newJString(farmId))
  add(path_564093, "subscriptionId", newJString(subscriptionId))
  add(path_564093, "resourceGroupName", newJString(resourceGroupName))
  result = call_564092.call(path_564093, query_564094, nil, nil, nil)

var farmsGet* = Call_FarmsGet_564084(name: "farmsGet", meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}",
                                  validator: validate_FarmsGet_564085, base: "",
                                  url: url_FarmsGet_564086,
                                  schemes: {Scheme.Https})
type
  Call_FarmsUpdate_564117 = ref object of OpenApiRestCall_563556
proc url_FarmsUpdate_564119(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FarmsUpdate_564118(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing storage farm.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `farmId` field"
  var valid_564120 = path.getOrDefault("farmId")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "farmId", valid_564120
  var valid_564121 = path.getOrDefault("subscriptionId")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "subscriptionId", valid_564121
  var valid_564122 = path.getOrDefault("resourceGroupName")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "resourceGroupName", valid_564122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564123 = query.getOrDefault("api-version")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "api-version", valid_564123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   farmObject: JObject (required)
  ##             : Farm to update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564125: Call_FarmsUpdate_564117; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing storage farm.
  ## 
  let valid = call_564125.validator(path, query, header, formData, body)
  let scheme = call_564125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564125.url(scheme.get, call_564125.host, call_564125.base,
                         call_564125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564125, url, valid)

proc call*(call_564126: Call_FarmsUpdate_564117; farmObject: JsonNode;
          apiVersion: string; farmId: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## farmsUpdate
  ## Update an existing storage farm.
  ##   farmObject: JObject (required)
  ##             : Farm to update.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  var path_564127 = newJObject()
  var query_564128 = newJObject()
  var body_564129 = newJObject()
  if farmObject != nil:
    body_564129 = farmObject
  add(query_564128, "api-version", newJString(apiVersion))
  add(path_564127, "farmId", newJString(farmId))
  add(path_564127, "subscriptionId", newJString(subscriptionId))
  add(path_564127, "resourceGroupName", newJString(resourceGroupName))
  result = call_564126.call(path_564127, query_564128, nil, nil, body_564129)

var farmsUpdate* = Call_FarmsUpdate_564117(name: "farmsUpdate",
                                        meth: HttpMethod.HttpPatch, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}",
                                        validator: validate_FarmsUpdate_564118,
                                        base: "", url: url_FarmsUpdate_564119,
                                        schemes: {Scheme.Https})
type
  Call_FarmsListMetricDefinitions_564130 = ref object of OpenApiRestCall_563556
proc url_FarmsListMetricDefinitions_564132(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/metricdefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FarmsListMetricDefinitions_564131(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of metric definitions for a storage farm.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `farmId` field"
  var valid_564133 = path.getOrDefault("farmId")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "farmId", valid_564133
  var valid_564134 = path.getOrDefault("subscriptionId")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "subscriptionId", valid_564134
  var valid_564135 = path.getOrDefault("resourceGroupName")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "resourceGroupName", valid_564135
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564136 = query.getOrDefault("api-version")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "api-version", valid_564136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564137: Call_FarmsListMetricDefinitions_564130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of metric definitions for a storage farm.
  ## 
  let valid = call_564137.validator(path, query, header, formData, body)
  let scheme = call_564137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564137.url(scheme.get, call_564137.host, call_564137.base,
                         call_564137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564137, url, valid)

proc call*(call_564138: Call_FarmsListMetricDefinitions_564130; apiVersion: string;
          farmId: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## farmsListMetricDefinitions
  ## Returns a list of metric definitions for a storage farm.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  var path_564139 = newJObject()
  var query_564140 = newJObject()
  add(query_564140, "api-version", newJString(apiVersion))
  add(path_564139, "farmId", newJString(farmId))
  add(path_564139, "subscriptionId", newJString(subscriptionId))
  add(path_564139, "resourceGroupName", newJString(resourceGroupName))
  result = call_564138.call(path_564139, query_564140, nil, nil, nil)

var farmsListMetricDefinitions* = Call_FarmsListMetricDefinitions_564130(
    name: "farmsListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/metricdefinitions",
    validator: validate_FarmsListMetricDefinitions_564131, base: "",
    url: url_FarmsListMetricDefinitions_564132, schemes: {Scheme.Https})
type
  Call_FarmsListMetrics_564141 = ref object of OpenApiRestCall_563556
proc url_FarmsListMetrics_564143(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FarmsListMetrics_564142(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns a list of storage farm metrics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `farmId` field"
  var valid_564144 = path.getOrDefault("farmId")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "farmId", valid_564144
  var valid_564145 = path.getOrDefault("subscriptionId")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "subscriptionId", valid_564145
  var valid_564146 = path.getOrDefault("resourceGroupName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "resourceGroupName", valid_564146
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564147 = query.getOrDefault("api-version")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "api-version", valid_564147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564148: Call_FarmsListMetrics_564141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of storage farm metrics.
  ## 
  let valid = call_564148.validator(path, query, header, formData, body)
  let scheme = call_564148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564148.url(scheme.get, call_564148.host, call_564148.base,
                         call_564148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564148, url, valid)

proc call*(call_564149: Call_FarmsListMetrics_564141; apiVersion: string;
          farmId: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## farmsListMetrics
  ## Returns a list of storage farm metrics.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  var path_564150 = newJObject()
  var query_564151 = newJObject()
  add(query_564151, "api-version", newJString(apiVersion))
  add(path_564150, "farmId", newJString(farmId))
  add(path_564150, "subscriptionId", newJString(subscriptionId))
  add(path_564150, "resourceGroupName", newJString(resourceGroupName))
  result = call_564149.call(path_564150, query_564151, nil, nil, nil)

var farmsListMetrics* = Call_FarmsListMetrics_564141(name: "farmsListMetrics",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/metrics",
    validator: validate_FarmsListMetrics_564142, base: "",
    url: url_FarmsListMetrics_564143, schemes: {Scheme.Https})
type
  Call_FarmsStartGarbageCollection_564152 = ref object of OpenApiRestCall_563556
proc url_FarmsStartGarbageCollection_564154(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/ondemandgc")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FarmsStartGarbageCollection_564153(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Start garbage collection on deleted storage objects.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `farmId` field"
  var valid_564155 = path.getOrDefault("farmId")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "farmId", valid_564155
  var valid_564156 = path.getOrDefault("subscriptionId")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "subscriptionId", valid_564156
  var valid_564157 = path.getOrDefault("resourceGroupName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "resourceGroupName", valid_564157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564158 = query.getOrDefault("api-version")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "api-version", valid_564158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564159: Call_FarmsStartGarbageCollection_564152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start garbage collection on deleted storage objects.
  ## 
  let valid = call_564159.validator(path, query, header, formData, body)
  let scheme = call_564159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564159.url(scheme.get, call_564159.host, call_564159.base,
                         call_564159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564159, url, valid)

proc call*(call_564160: Call_FarmsStartGarbageCollection_564152;
          apiVersion: string; farmId: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## farmsStartGarbageCollection
  ## Start garbage collection on deleted storage objects.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  var path_564161 = newJObject()
  var query_564162 = newJObject()
  add(query_564162, "api-version", newJString(apiVersion))
  add(path_564161, "farmId", newJString(farmId))
  add(path_564161, "subscriptionId", newJString(subscriptionId))
  add(path_564161, "resourceGroupName", newJString(resourceGroupName))
  result = call_564160.call(path_564161, query_564162, nil, nil, nil)

var farmsStartGarbageCollection* = Call_FarmsStartGarbageCollection_564152(
    name: "farmsStartGarbageCollection", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/ondemandgc",
    validator: validate_FarmsStartGarbageCollection_564153, base: "",
    url: url_FarmsStartGarbageCollection_564154, schemes: {Scheme.Https})
type
  Call_FarmsGetGarbageCollectionState_564163 = ref object of OpenApiRestCall_563556
proc url_FarmsGetGarbageCollectionState_564165(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/operationresults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FarmsGetGarbageCollectionState_564164(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the state of the garbage collection job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : Operation Id.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_564166 = path.getOrDefault("operationId")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "operationId", valid_564166
  var valid_564167 = path.getOrDefault("farmId")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "farmId", valid_564167
  var valid_564168 = path.getOrDefault("subscriptionId")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "subscriptionId", valid_564168
  var valid_564169 = path.getOrDefault("resourceGroupName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "resourceGroupName", valid_564169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564170 = query.getOrDefault("api-version")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "api-version", valid_564170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564171: Call_FarmsGetGarbageCollectionState_564163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the state of the garbage collection job.
  ## 
  let valid = call_564171.validator(path, query, header, formData, body)
  let scheme = call_564171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564171.url(scheme.get, call_564171.host, call_564171.base,
                         call_564171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564171, url, valid)

proc call*(call_564172: Call_FarmsGetGarbageCollectionState_564163;
          apiVersion: string; operationId: string; farmId: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## farmsGetGarbageCollectionState
  ## Returns the state of the garbage collection job.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   operationId: string (required)
  ##              : Operation Id.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  var path_564173 = newJObject()
  var query_564174 = newJObject()
  add(query_564174, "api-version", newJString(apiVersion))
  add(path_564173, "operationId", newJString(operationId))
  add(path_564173, "farmId", newJString(farmId))
  add(path_564173, "subscriptionId", newJString(subscriptionId))
  add(path_564173, "resourceGroupName", newJString(resourceGroupName))
  result = call_564172.call(path_564173, query_564174, nil, nil, nil)

var farmsGetGarbageCollectionState* = Call_FarmsGetGarbageCollectionState_564163(
    name: "farmsGetGarbageCollectionState", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/operationresults/{operationId}",
    validator: validate_FarmsGetGarbageCollectionState_564164, base: "",
    url: url_FarmsGetGarbageCollectionState_564165, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
