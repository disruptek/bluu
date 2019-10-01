
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_574458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574458): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-farms"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FarmsList_574680 = ref object of OpenApiRestCall_574458
proc url_FarmsList_574682(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_FarmsList_574681(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of all storage farms.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574842 = path.getOrDefault("resourceGroupName")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = nil)
  if valid_574842 != nil:
    section.add "resourceGroupName", valid_574842
  var valid_574843 = path.getOrDefault("subscriptionId")
  valid_574843 = validateParameter(valid_574843, JString, required = true,
                                 default = nil)
  if valid_574843 != nil:
    section.add "subscriptionId", valid_574843
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574844 = query.getOrDefault("api-version")
  valid_574844 = validateParameter(valid_574844, JString, required = true,
                                 default = nil)
  if valid_574844 != nil:
    section.add "api-version", valid_574844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574871: Call_FarmsList_574680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all storage farms.
  ## 
  let valid = call_574871.validator(path, query, header, formData, body)
  let scheme = call_574871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574871.url(scheme.get, call_574871.host, call_574871.base,
                         call_574871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574871, url, valid)

proc call*(call_574942: Call_FarmsList_574680; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## farmsList
  ## Returns a list of all storage farms.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  var path_574943 = newJObject()
  var query_574945 = newJObject()
  add(path_574943, "resourceGroupName", newJString(resourceGroupName))
  add(query_574945, "api-version", newJString(apiVersion))
  add(path_574943, "subscriptionId", newJString(subscriptionId))
  result = call_574942.call(path_574943, query_574945, nil, nil, nil)

var farmsList* = Call_FarmsList_574680(name: "farmsList", meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms",
                                    validator: validate_FarmsList_574681,
                                    base: "", url: url_FarmsList_574682,
                                    schemes: {Scheme.Https})
type
  Call_FarmsCreate_574995 = ref object of OpenApiRestCall_574458
proc url_FarmsCreate_574997(protocol: Scheme; host: string; base: string;
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

proc validate_FarmsCreate_574996(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new storage farm.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575007 = path.getOrDefault("resourceGroupName")
  valid_575007 = validateParameter(valid_575007, JString, required = true,
                                 default = nil)
  if valid_575007 != nil:
    section.add "resourceGroupName", valid_575007
  var valid_575008 = path.getOrDefault("farmId")
  valid_575008 = validateParameter(valid_575008, JString, required = true,
                                 default = nil)
  if valid_575008 != nil:
    section.add "farmId", valid_575008
  var valid_575009 = path.getOrDefault("subscriptionId")
  valid_575009 = validateParameter(valid_575009, JString, required = true,
                                 default = nil)
  if valid_575009 != nil:
    section.add "subscriptionId", valid_575009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575010 = query.getOrDefault("api-version")
  valid_575010 = validateParameter(valid_575010, JString, required = true,
                                 default = nil)
  if valid_575010 != nil:
    section.add "api-version", valid_575010
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

proc call*(call_575012: Call_FarmsCreate_574995; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new storage farm.
  ## 
  let valid = call_575012.validator(path, query, header, formData, body)
  let scheme = call_575012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575012.url(scheme.get, call_575012.host, call_575012.base,
                         call_575012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575012, url, valid)

proc call*(call_575013: Call_FarmsCreate_574995; farmObject: JsonNode;
          resourceGroupName: string; apiVersion: string; farmId: string;
          subscriptionId: string): Recallable =
  ## farmsCreate
  ## Create a new storage farm.
  ##   farmObject: JObject (required)
  ##             : Parameters used to create a farm
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  var path_575014 = newJObject()
  var query_575015 = newJObject()
  var body_575016 = newJObject()
  if farmObject != nil:
    body_575016 = farmObject
  add(path_575014, "resourceGroupName", newJString(resourceGroupName))
  add(query_575015, "api-version", newJString(apiVersion))
  add(path_575014, "farmId", newJString(farmId))
  add(path_575014, "subscriptionId", newJString(subscriptionId))
  result = call_575013.call(path_575014, query_575015, nil, nil, body_575016)

var farmsCreate* = Call_FarmsCreate_574995(name: "farmsCreate",
                                        meth: HttpMethod.HttpPut, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}",
                                        validator: validate_FarmsCreate_574996,
                                        base: "", url: url_FarmsCreate_574997,
                                        schemes: {Scheme.Https})
type
  Call_FarmsGet_574984 = ref object of OpenApiRestCall_574458
proc url_FarmsGet_574986(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_FarmsGet_574985(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the Storage properties and settings for a specified storage farm.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574987 = path.getOrDefault("resourceGroupName")
  valid_574987 = validateParameter(valid_574987, JString, required = true,
                                 default = nil)
  if valid_574987 != nil:
    section.add "resourceGroupName", valid_574987
  var valid_574988 = path.getOrDefault("farmId")
  valid_574988 = validateParameter(valid_574988, JString, required = true,
                                 default = nil)
  if valid_574988 != nil:
    section.add "farmId", valid_574988
  var valid_574989 = path.getOrDefault("subscriptionId")
  valid_574989 = validateParameter(valid_574989, JString, required = true,
                                 default = nil)
  if valid_574989 != nil:
    section.add "subscriptionId", valid_574989
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574990 = query.getOrDefault("api-version")
  valid_574990 = validateParameter(valid_574990, JString, required = true,
                                 default = nil)
  if valid_574990 != nil:
    section.add "api-version", valid_574990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574991: Call_FarmsGet_574984; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the Storage properties and settings for a specified storage farm.
  ## 
  let valid = call_574991.validator(path, query, header, formData, body)
  let scheme = call_574991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574991.url(scheme.get, call_574991.host, call_574991.base,
                         call_574991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574991, url, valid)

proc call*(call_574992: Call_FarmsGet_574984; resourceGroupName: string;
          apiVersion: string; farmId: string; subscriptionId: string): Recallable =
  ## farmsGet
  ## Returns the Storage properties and settings for a specified storage farm.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  var path_574993 = newJObject()
  var query_574994 = newJObject()
  add(path_574993, "resourceGroupName", newJString(resourceGroupName))
  add(query_574994, "api-version", newJString(apiVersion))
  add(path_574993, "farmId", newJString(farmId))
  add(path_574993, "subscriptionId", newJString(subscriptionId))
  result = call_574992.call(path_574993, query_574994, nil, nil, nil)

var farmsGet* = Call_FarmsGet_574984(name: "farmsGet", meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}",
                                  validator: validate_FarmsGet_574985, base: "",
                                  url: url_FarmsGet_574986,
                                  schemes: {Scheme.Https})
type
  Call_FarmsUpdate_575017 = ref object of OpenApiRestCall_574458
proc url_FarmsUpdate_575019(protocol: Scheme; host: string; base: string;
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

proc validate_FarmsUpdate_575018(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing storage farm.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575020 = path.getOrDefault("resourceGroupName")
  valid_575020 = validateParameter(valid_575020, JString, required = true,
                                 default = nil)
  if valid_575020 != nil:
    section.add "resourceGroupName", valid_575020
  var valid_575021 = path.getOrDefault("farmId")
  valid_575021 = validateParameter(valid_575021, JString, required = true,
                                 default = nil)
  if valid_575021 != nil:
    section.add "farmId", valid_575021
  var valid_575022 = path.getOrDefault("subscriptionId")
  valid_575022 = validateParameter(valid_575022, JString, required = true,
                                 default = nil)
  if valid_575022 != nil:
    section.add "subscriptionId", valid_575022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575023 = query.getOrDefault("api-version")
  valid_575023 = validateParameter(valid_575023, JString, required = true,
                                 default = nil)
  if valid_575023 != nil:
    section.add "api-version", valid_575023
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

proc call*(call_575025: Call_FarmsUpdate_575017; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing storage farm.
  ## 
  let valid = call_575025.validator(path, query, header, formData, body)
  let scheme = call_575025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575025.url(scheme.get, call_575025.host, call_575025.base,
                         call_575025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575025, url, valid)

proc call*(call_575026: Call_FarmsUpdate_575017; farmObject: JsonNode;
          resourceGroupName: string; apiVersion: string; farmId: string;
          subscriptionId: string): Recallable =
  ## farmsUpdate
  ## Update an existing storage farm.
  ##   farmObject: JObject (required)
  ##             : Farm to update.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  var path_575027 = newJObject()
  var query_575028 = newJObject()
  var body_575029 = newJObject()
  if farmObject != nil:
    body_575029 = farmObject
  add(path_575027, "resourceGroupName", newJString(resourceGroupName))
  add(query_575028, "api-version", newJString(apiVersion))
  add(path_575027, "farmId", newJString(farmId))
  add(path_575027, "subscriptionId", newJString(subscriptionId))
  result = call_575026.call(path_575027, query_575028, nil, nil, body_575029)

var farmsUpdate* = Call_FarmsUpdate_575017(name: "farmsUpdate",
                                        meth: HttpMethod.HttpPatch, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}",
                                        validator: validate_FarmsUpdate_575018,
                                        base: "", url: url_FarmsUpdate_575019,
                                        schemes: {Scheme.Https})
type
  Call_FarmsListMetricDefinitions_575030 = ref object of OpenApiRestCall_574458
proc url_FarmsListMetricDefinitions_575032(protocol: Scheme; host: string;
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

proc validate_FarmsListMetricDefinitions_575031(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of metric definitions for a storage farm.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575033 = path.getOrDefault("resourceGroupName")
  valid_575033 = validateParameter(valid_575033, JString, required = true,
                                 default = nil)
  if valid_575033 != nil:
    section.add "resourceGroupName", valid_575033
  var valid_575034 = path.getOrDefault("farmId")
  valid_575034 = validateParameter(valid_575034, JString, required = true,
                                 default = nil)
  if valid_575034 != nil:
    section.add "farmId", valid_575034
  var valid_575035 = path.getOrDefault("subscriptionId")
  valid_575035 = validateParameter(valid_575035, JString, required = true,
                                 default = nil)
  if valid_575035 != nil:
    section.add "subscriptionId", valid_575035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575036 = query.getOrDefault("api-version")
  valid_575036 = validateParameter(valid_575036, JString, required = true,
                                 default = nil)
  if valid_575036 != nil:
    section.add "api-version", valid_575036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575037: Call_FarmsListMetricDefinitions_575030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of metric definitions for a storage farm.
  ## 
  let valid = call_575037.validator(path, query, header, formData, body)
  let scheme = call_575037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575037.url(scheme.get, call_575037.host, call_575037.base,
                         call_575037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575037, url, valid)

proc call*(call_575038: Call_FarmsListMetricDefinitions_575030;
          resourceGroupName: string; apiVersion: string; farmId: string;
          subscriptionId: string): Recallable =
  ## farmsListMetricDefinitions
  ## Returns a list of metric definitions for a storage farm.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  var path_575039 = newJObject()
  var query_575040 = newJObject()
  add(path_575039, "resourceGroupName", newJString(resourceGroupName))
  add(query_575040, "api-version", newJString(apiVersion))
  add(path_575039, "farmId", newJString(farmId))
  add(path_575039, "subscriptionId", newJString(subscriptionId))
  result = call_575038.call(path_575039, query_575040, nil, nil, nil)

var farmsListMetricDefinitions* = Call_FarmsListMetricDefinitions_575030(
    name: "farmsListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/metricdefinitions",
    validator: validate_FarmsListMetricDefinitions_575031, base: "",
    url: url_FarmsListMetricDefinitions_575032, schemes: {Scheme.Https})
type
  Call_FarmsListMetrics_575041 = ref object of OpenApiRestCall_574458
proc url_FarmsListMetrics_575043(protocol: Scheme; host: string; base: string;
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

proc validate_FarmsListMetrics_575042(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns a list of storage farm metrics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575044 = path.getOrDefault("resourceGroupName")
  valid_575044 = validateParameter(valid_575044, JString, required = true,
                                 default = nil)
  if valid_575044 != nil:
    section.add "resourceGroupName", valid_575044
  var valid_575045 = path.getOrDefault("farmId")
  valid_575045 = validateParameter(valid_575045, JString, required = true,
                                 default = nil)
  if valid_575045 != nil:
    section.add "farmId", valid_575045
  var valid_575046 = path.getOrDefault("subscriptionId")
  valid_575046 = validateParameter(valid_575046, JString, required = true,
                                 default = nil)
  if valid_575046 != nil:
    section.add "subscriptionId", valid_575046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575047 = query.getOrDefault("api-version")
  valid_575047 = validateParameter(valid_575047, JString, required = true,
                                 default = nil)
  if valid_575047 != nil:
    section.add "api-version", valid_575047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575048: Call_FarmsListMetrics_575041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of storage farm metrics.
  ## 
  let valid = call_575048.validator(path, query, header, formData, body)
  let scheme = call_575048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575048.url(scheme.get, call_575048.host, call_575048.base,
                         call_575048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575048, url, valid)

proc call*(call_575049: Call_FarmsListMetrics_575041; resourceGroupName: string;
          apiVersion: string; farmId: string; subscriptionId: string): Recallable =
  ## farmsListMetrics
  ## Returns a list of storage farm metrics.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  var path_575050 = newJObject()
  var query_575051 = newJObject()
  add(path_575050, "resourceGroupName", newJString(resourceGroupName))
  add(query_575051, "api-version", newJString(apiVersion))
  add(path_575050, "farmId", newJString(farmId))
  add(path_575050, "subscriptionId", newJString(subscriptionId))
  result = call_575049.call(path_575050, query_575051, nil, nil, nil)

var farmsListMetrics* = Call_FarmsListMetrics_575041(name: "farmsListMetrics",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/metrics",
    validator: validate_FarmsListMetrics_575042, base: "",
    url: url_FarmsListMetrics_575043, schemes: {Scheme.Https})
type
  Call_FarmsStartGarbageCollection_575052 = ref object of OpenApiRestCall_574458
proc url_FarmsStartGarbageCollection_575054(protocol: Scheme; host: string;
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

proc validate_FarmsStartGarbageCollection_575053(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Start garbage collection on deleted storage objects.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575055 = path.getOrDefault("resourceGroupName")
  valid_575055 = validateParameter(valid_575055, JString, required = true,
                                 default = nil)
  if valid_575055 != nil:
    section.add "resourceGroupName", valid_575055
  var valid_575056 = path.getOrDefault("farmId")
  valid_575056 = validateParameter(valid_575056, JString, required = true,
                                 default = nil)
  if valid_575056 != nil:
    section.add "farmId", valid_575056
  var valid_575057 = path.getOrDefault("subscriptionId")
  valid_575057 = validateParameter(valid_575057, JString, required = true,
                                 default = nil)
  if valid_575057 != nil:
    section.add "subscriptionId", valid_575057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575058 = query.getOrDefault("api-version")
  valid_575058 = validateParameter(valid_575058, JString, required = true,
                                 default = nil)
  if valid_575058 != nil:
    section.add "api-version", valid_575058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575059: Call_FarmsStartGarbageCollection_575052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start garbage collection on deleted storage objects.
  ## 
  let valid = call_575059.validator(path, query, header, formData, body)
  let scheme = call_575059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575059.url(scheme.get, call_575059.host, call_575059.base,
                         call_575059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575059, url, valid)

proc call*(call_575060: Call_FarmsStartGarbageCollection_575052;
          resourceGroupName: string; apiVersion: string; farmId: string;
          subscriptionId: string): Recallable =
  ## farmsStartGarbageCollection
  ## Start garbage collection on deleted storage objects.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  var path_575061 = newJObject()
  var query_575062 = newJObject()
  add(path_575061, "resourceGroupName", newJString(resourceGroupName))
  add(query_575062, "api-version", newJString(apiVersion))
  add(path_575061, "farmId", newJString(farmId))
  add(path_575061, "subscriptionId", newJString(subscriptionId))
  result = call_575060.call(path_575061, query_575062, nil, nil, nil)

var farmsStartGarbageCollection* = Call_FarmsStartGarbageCollection_575052(
    name: "farmsStartGarbageCollection", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/ondemandgc",
    validator: validate_FarmsStartGarbageCollection_575053, base: "",
    url: url_FarmsStartGarbageCollection_575054, schemes: {Scheme.Https})
type
  Call_FarmsGetGarbageCollectionState_575063 = ref object of OpenApiRestCall_574458
proc url_FarmsGetGarbageCollectionState_575065(protocol: Scheme; host: string;
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

proc validate_FarmsGetGarbageCollectionState_575064(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the state of the garbage collection job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   operationId: JString (required)
  ##              : Operation Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575066 = path.getOrDefault("resourceGroupName")
  valid_575066 = validateParameter(valid_575066, JString, required = true,
                                 default = nil)
  if valid_575066 != nil:
    section.add "resourceGroupName", valid_575066
  var valid_575067 = path.getOrDefault("farmId")
  valid_575067 = validateParameter(valid_575067, JString, required = true,
                                 default = nil)
  if valid_575067 != nil:
    section.add "farmId", valid_575067
  var valid_575068 = path.getOrDefault("subscriptionId")
  valid_575068 = validateParameter(valid_575068, JString, required = true,
                                 default = nil)
  if valid_575068 != nil:
    section.add "subscriptionId", valid_575068
  var valid_575069 = path.getOrDefault("operationId")
  valid_575069 = validateParameter(valid_575069, JString, required = true,
                                 default = nil)
  if valid_575069 != nil:
    section.add "operationId", valid_575069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575070 = query.getOrDefault("api-version")
  valid_575070 = validateParameter(valid_575070, JString, required = true,
                                 default = nil)
  if valid_575070 != nil:
    section.add "api-version", valid_575070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575071: Call_FarmsGetGarbageCollectionState_575063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the state of the garbage collection job.
  ## 
  let valid = call_575071.validator(path, query, header, formData, body)
  let scheme = call_575071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575071.url(scheme.get, call_575071.host, call_575071.base,
                         call_575071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575071, url, valid)

proc call*(call_575072: Call_FarmsGetGarbageCollectionState_575063;
          resourceGroupName: string; apiVersion: string; farmId: string;
          subscriptionId: string; operationId: string): Recallable =
  ## farmsGetGarbageCollectionState
  ## Returns the state of the garbage collection job.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   operationId: string (required)
  ##              : Operation Id.
  var path_575073 = newJObject()
  var query_575074 = newJObject()
  add(path_575073, "resourceGroupName", newJString(resourceGroupName))
  add(query_575074, "api-version", newJString(apiVersion))
  add(path_575073, "farmId", newJString(farmId))
  add(path_575073, "subscriptionId", newJString(subscriptionId))
  add(path_575073, "operationId", newJString(operationId))
  result = call_575072.call(path_575073, query_575074, nil, nil, nil)

var farmsGetGarbageCollectionState* = Call_FarmsGetGarbageCollectionState_575063(
    name: "farmsGetGarbageCollectionState", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/operationresults/{operationId}",
    validator: validate_FarmsGetGarbageCollectionState_575064, base: "",
    url: url_FarmsGetGarbageCollectionState_575065, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
