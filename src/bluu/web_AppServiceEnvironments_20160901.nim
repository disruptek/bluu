
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: AppServiceEnvironments API Client
## version: 2016-09-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "web-AppServiceEnvironments"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppServiceEnvironmentsList_563777 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsList_563779(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Web/hostingEnvironments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsList_563778(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all App Service Environments for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563954 = path.getOrDefault("subscriptionId")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = nil)
  if valid_563954 != nil:
    section.add "subscriptionId", valid_563954
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563955 = query.getOrDefault("api-version")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "api-version", valid_563955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563978: Call_AppServiceEnvironmentsList_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all App Service Environments for a subscription.
  ## 
  let valid = call_563978.validator(path, query, header, formData, body)
  let scheme = call_563978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563978.url(scheme.get, call_563978.host, call_563978.base,
                         call_563978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563978, url, valid)

proc call*(call_564049: Call_AppServiceEnvironmentsList_563777; apiVersion: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsList
  ## Get all App Service Environments for a subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_564050 = newJObject()
  var query_564052 = newJObject()
  add(query_564052, "api-version", newJString(apiVersion))
  add(path_564050, "subscriptionId", newJString(subscriptionId))
  result = call_564049.call(path_564050, query_564052, nil, nil, nil)

var appServiceEnvironmentsList* = Call_AppServiceEnvironmentsList_563777(
    name: "appServiceEnvironmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/hostingEnvironments",
    validator: validate_AppServiceEnvironmentsList_563778, base: "",
    url: url_AppServiceEnvironmentsList_563779, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListByResourceGroup_564091 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListByResourceGroup_564093(protocol: Scheme;
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
        value: "/providers/Microsoft.Web/hostingEnvironments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListByResourceGroup_564092(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all App Service Environments in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564094 = path.getOrDefault("subscriptionId")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "subscriptionId", valid_564094
  var valid_564095 = path.getOrDefault("resourceGroupName")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "resourceGroupName", valid_564095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564096 = query.getOrDefault("api-version")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "api-version", valid_564096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564097: Call_AppServiceEnvironmentsListByResourceGroup_564091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all App Service Environments in a resource group.
  ## 
  let valid = call_564097.validator(path, query, header, formData, body)
  let scheme = call_564097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564097.url(scheme.get, call_564097.host, call_564097.base,
                         call_564097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564097, url, valid)

proc call*(call_564098: Call_AppServiceEnvironmentsListByResourceGroup_564091;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsListByResourceGroup
  ## Get all App Service Environments in a resource group.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564099 = newJObject()
  var query_564100 = newJObject()
  add(query_564100, "api-version", newJString(apiVersion))
  add(path_564099, "subscriptionId", newJString(subscriptionId))
  add(path_564099, "resourceGroupName", newJString(resourceGroupName))
  result = call_564098.call(path_564099, query_564100, nil, nil, nil)

var appServiceEnvironmentsListByResourceGroup* = Call_AppServiceEnvironmentsListByResourceGroup_564091(
    name: "appServiceEnvironmentsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments",
    validator: validate_AppServiceEnvironmentsListByResourceGroup_564092,
    base: "", url: url_AppServiceEnvironmentsListByResourceGroup_564093,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsCreateOrUpdate_564112 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsCreateOrUpdate_564114(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsCreateOrUpdate_564113(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564115 = path.getOrDefault("name")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "name", valid_564115
  var valid_564116 = path.getOrDefault("subscriptionId")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "subscriptionId", valid_564116
  var valid_564117 = path.getOrDefault("resourceGroupName")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "resourceGroupName", valid_564117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564118 = query.getOrDefault("api-version")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "api-version", valid_564118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   hostingEnvironmentEnvelope: JObject (required)
  ##                             : Configuration details of the App Service Environment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564120: Call_AppServiceEnvironmentsCreateOrUpdate_564112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an App Service Environment.
  ## 
  let valid = call_564120.validator(path, query, header, formData, body)
  let scheme = call_564120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564120.url(scheme.get, call_564120.host, call_564120.base,
                         call_564120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564120, url, valid)

proc call*(call_564121: Call_AppServiceEnvironmentsCreateOrUpdate_564112;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string; hostingEnvironmentEnvelope: JsonNode): Recallable =
  ## appServiceEnvironmentsCreateOrUpdate
  ## Create or update an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   hostingEnvironmentEnvelope: JObject (required)
  ##                             : Configuration details of the App Service Environment.
  var path_564122 = newJObject()
  var query_564123 = newJObject()
  var body_564124 = newJObject()
  add(query_564123, "api-version", newJString(apiVersion))
  add(path_564122, "name", newJString(name))
  add(path_564122, "subscriptionId", newJString(subscriptionId))
  add(path_564122, "resourceGroupName", newJString(resourceGroupName))
  if hostingEnvironmentEnvelope != nil:
    body_564124 = hostingEnvironmentEnvelope
  result = call_564121.call(path_564122, query_564123, nil, nil, body_564124)

var appServiceEnvironmentsCreateOrUpdate* = Call_AppServiceEnvironmentsCreateOrUpdate_564112(
    name: "appServiceEnvironmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsCreateOrUpdate_564113, base: "",
    url: url_AppServiceEnvironmentsCreateOrUpdate_564114, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGet_564101 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsGet_564103(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsGet_564102(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the properties of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564104 = path.getOrDefault("name")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "name", valid_564104
  var valid_564105 = path.getOrDefault("subscriptionId")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "subscriptionId", valid_564105
  var valid_564106 = path.getOrDefault("resourceGroupName")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "resourceGroupName", valid_564106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564107 = query.getOrDefault("api-version")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "api-version", valid_564107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564108: Call_AppServiceEnvironmentsGet_564101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the properties of an App Service Environment.
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_AppServiceEnvironmentsGet_564101; apiVersion: string;
          name: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsGet
  ## Get the properties of an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564110 = newJObject()
  var query_564111 = newJObject()
  add(query_564111, "api-version", newJString(apiVersion))
  add(path_564110, "name", newJString(name))
  add(path_564110, "subscriptionId", newJString(subscriptionId))
  add(path_564110, "resourceGroupName", newJString(resourceGroupName))
  result = call_564109.call(path_564110, query_564111, nil, nil, nil)

var appServiceEnvironmentsGet* = Call_AppServiceEnvironmentsGet_564101(
    name: "appServiceEnvironmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsGet_564102, base: "",
    url: url_AppServiceEnvironmentsGet_564103, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsUpdate_564137 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsUpdate_564139(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsUpdate_564138(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564140 = path.getOrDefault("name")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "name", valid_564140
  var valid_564141 = path.getOrDefault("subscriptionId")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "subscriptionId", valid_564141
  var valid_564142 = path.getOrDefault("resourceGroupName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "resourceGroupName", valid_564142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "api-version", valid_564143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   hostingEnvironmentEnvelope: JObject (required)
  ##                             : Configuration details of the App Service Environment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564145: Call_AppServiceEnvironmentsUpdate_564137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an App Service Environment.
  ## 
  let valid = call_564145.validator(path, query, header, formData, body)
  let scheme = call_564145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564145.url(scheme.get, call_564145.host, call_564145.base,
                         call_564145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564145, url, valid)

proc call*(call_564146: Call_AppServiceEnvironmentsUpdate_564137;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string; hostingEnvironmentEnvelope: JsonNode): Recallable =
  ## appServiceEnvironmentsUpdate
  ## Create or update an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   hostingEnvironmentEnvelope: JObject (required)
  ##                             : Configuration details of the App Service Environment.
  var path_564147 = newJObject()
  var query_564148 = newJObject()
  var body_564149 = newJObject()
  add(query_564148, "api-version", newJString(apiVersion))
  add(path_564147, "name", newJString(name))
  add(path_564147, "subscriptionId", newJString(subscriptionId))
  add(path_564147, "resourceGroupName", newJString(resourceGroupName))
  if hostingEnvironmentEnvelope != nil:
    body_564149 = hostingEnvironmentEnvelope
  result = call_564146.call(path_564147, query_564148, nil, nil, body_564149)

var appServiceEnvironmentsUpdate* = Call_AppServiceEnvironmentsUpdate_564137(
    name: "appServiceEnvironmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsUpdate_564138, base: "",
    url: url_AppServiceEnvironmentsUpdate_564139, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsDelete_564125 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsDelete_564127(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsDelete_564126(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564128 = path.getOrDefault("name")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "name", valid_564128
  var valid_564129 = path.getOrDefault("subscriptionId")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "subscriptionId", valid_564129
  var valid_564130 = path.getOrDefault("resourceGroupName")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "resourceGroupName", valid_564130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   forceDelete: JBool
  ##              : Specify <code>true</code> to force the deletion even if the App Service Environment contains resources. The default is <code>false</code>.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564131 = query.getOrDefault("api-version")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "api-version", valid_564131
  var valid_564132 = query.getOrDefault("forceDelete")
  valid_564132 = validateParameter(valid_564132, JBool, required = false, default = nil)
  if valid_564132 != nil:
    section.add "forceDelete", valid_564132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564133: Call_AppServiceEnvironmentsDelete_564125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an App Service Environment.
  ## 
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_AppServiceEnvironmentsDelete_564125;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string; forceDelete: bool = false): Recallable =
  ## appServiceEnvironmentsDelete
  ## Delete an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   forceDelete: bool
  ##              : Specify <code>true</code> to force the deletion even if the App Service Environment contains resources. The default is <code>false</code>.
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  add(query_564136, "api-version", newJString(apiVersion))
  add(path_564135, "name", newJString(name))
  add(path_564135, "subscriptionId", newJString(subscriptionId))
  add(path_564135, "resourceGroupName", newJString(resourceGroupName))
  add(query_564136, "forceDelete", newJBool(forceDelete))
  result = call_564134.call(path_564135, query_564136, nil, nil, nil)

var appServiceEnvironmentsDelete* = Call_AppServiceEnvironmentsDelete_564125(
    name: "appServiceEnvironmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsDelete_564126, base: "",
    url: url_AppServiceEnvironmentsDelete_564127, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListCapacities_564150 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListCapacities_564152(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/capacities/compute")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListCapacities_564151(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the used, available, and total worker capacity an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564153 = path.getOrDefault("name")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "name", valid_564153
  var valid_564154 = path.getOrDefault("subscriptionId")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "subscriptionId", valid_564154
  var valid_564155 = path.getOrDefault("resourceGroupName")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "resourceGroupName", valid_564155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564156 = query.getOrDefault("api-version")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "api-version", valid_564156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564157: Call_AppServiceEnvironmentsListCapacities_564150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the used, available, and total worker capacity an App Service Environment.
  ## 
  let valid = call_564157.validator(path, query, header, formData, body)
  let scheme = call_564157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564157.url(scheme.get, call_564157.host, call_564157.base,
                         call_564157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564157, url, valid)

proc call*(call_564158: Call_AppServiceEnvironmentsListCapacities_564150;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsListCapacities
  ## Get the used, available, and total worker capacity an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564159 = newJObject()
  var query_564160 = newJObject()
  add(query_564160, "api-version", newJString(apiVersion))
  add(path_564159, "name", newJString(name))
  add(path_564159, "subscriptionId", newJString(subscriptionId))
  add(path_564159, "resourceGroupName", newJString(resourceGroupName))
  result = call_564158.call(path_564159, query_564160, nil, nil, nil)

var appServiceEnvironmentsListCapacities* = Call_AppServiceEnvironmentsListCapacities_564150(
    name: "appServiceEnvironmentsListCapacities", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/capacities/compute",
    validator: validate_AppServiceEnvironmentsListCapacities_564151, base: "",
    url: url_AppServiceEnvironmentsListCapacities_564152, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListVips_564161 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListVips_564163(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/capacities/virtualip")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListVips_564162(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get IP addresses assigned to an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564164 = path.getOrDefault("name")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "name", valid_564164
  var valid_564165 = path.getOrDefault("subscriptionId")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "subscriptionId", valid_564165
  var valid_564166 = path.getOrDefault("resourceGroupName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "resourceGroupName", valid_564166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564167 = query.getOrDefault("api-version")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "api-version", valid_564167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564168: Call_AppServiceEnvironmentsListVips_564161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get IP addresses assigned to an App Service Environment.
  ## 
  let valid = call_564168.validator(path, query, header, formData, body)
  let scheme = call_564168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564168.url(scheme.get, call_564168.host, call_564168.base,
                         call_564168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564168, url, valid)

proc call*(call_564169: Call_AppServiceEnvironmentsListVips_564161;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsListVips
  ## Get IP addresses assigned to an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564170 = newJObject()
  var query_564171 = newJObject()
  add(query_564171, "api-version", newJString(apiVersion))
  add(path_564170, "name", newJString(name))
  add(path_564170, "subscriptionId", newJString(subscriptionId))
  add(path_564170, "resourceGroupName", newJString(resourceGroupName))
  result = call_564169.call(path_564170, query_564171, nil, nil, nil)

var appServiceEnvironmentsListVips* = Call_AppServiceEnvironmentsListVips_564161(
    name: "appServiceEnvironmentsListVips", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/capacities/virtualip",
    validator: validate_AppServiceEnvironmentsListVips_564162, base: "",
    url: url_AppServiceEnvironmentsListVips_564163, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListDiagnostics_564172 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListDiagnostics_564174(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/diagnostics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListDiagnostics_564173(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get diagnostic information for an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564175 = path.getOrDefault("name")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "name", valid_564175
  var valid_564176 = path.getOrDefault("subscriptionId")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "subscriptionId", valid_564176
  var valid_564177 = path.getOrDefault("resourceGroupName")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "resourceGroupName", valid_564177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564178 = query.getOrDefault("api-version")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "api-version", valid_564178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564179: Call_AppServiceEnvironmentsListDiagnostics_564172;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get diagnostic information for an App Service Environment.
  ## 
  let valid = call_564179.validator(path, query, header, formData, body)
  let scheme = call_564179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564179.url(scheme.get, call_564179.host, call_564179.base,
                         call_564179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564179, url, valid)

proc call*(call_564180: Call_AppServiceEnvironmentsListDiagnostics_564172;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsListDiagnostics
  ## Get diagnostic information for an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564181 = newJObject()
  var query_564182 = newJObject()
  add(query_564182, "api-version", newJString(apiVersion))
  add(path_564181, "name", newJString(name))
  add(path_564181, "subscriptionId", newJString(subscriptionId))
  add(path_564181, "resourceGroupName", newJString(resourceGroupName))
  result = call_564180.call(path_564181, query_564182, nil, nil, nil)

var appServiceEnvironmentsListDiagnostics* = Call_AppServiceEnvironmentsListDiagnostics_564172(
    name: "appServiceEnvironmentsListDiagnostics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/diagnostics",
    validator: validate_AppServiceEnvironmentsListDiagnostics_564173, base: "",
    url: url_AppServiceEnvironmentsListDiagnostics_564174, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetDiagnosticsItem_564183 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsGetDiagnosticsItem_564185(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "diagnosticsName" in path, "`diagnosticsName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticsName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsGetDiagnosticsItem_564184(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a diagnostics item for an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   diagnosticsName: JString (required)
  ##                  : Name of the diagnostics item.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564186 = path.getOrDefault("name")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "name", valid_564186
  var valid_564187 = path.getOrDefault("subscriptionId")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "subscriptionId", valid_564187
  var valid_564188 = path.getOrDefault("diagnosticsName")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "diagnosticsName", valid_564188
  var valid_564189 = path.getOrDefault("resourceGroupName")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "resourceGroupName", valid_564189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564190 = query.getOrDefault("api-version")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "api-version", valid_564190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564191: Call_AppServiceEnvironmentsGetDiagnosticsItem_564183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a diagnostics item for an App Service Environment.
  ## 
  let valid = call_564191.validator(path, query, header, formData, body)
  let scheme = call_564191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564191.url(scheme.get, call_564191.host, call_564191.base,
                         call_564191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564191, url, valid)

proc call*(call_564192: Call_AppServiceEnvironmentsGetDiagnosticsItem_564183;
          apiVersion: string; name: string; subscriptionId: string;
          diagnosticsName: string; resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsGetDiagnosticsItem
  ## Get a diagnostics item for an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   diagnosticsName: string (required)
  ##                  : Name of the diagnostics item.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564193 = newJObject()
  var query_564194 = newJObject()
  add(query_564194, "api-version", newJString(apiVersion))
  add(path_564193, "name", newJString(name))
  add(path_564193, "subscriptionId", newJString(subscriptionId))
  add(path_564193, "diagnosticsName", newJString(diagnosticsName))
  add(path_564193, "resourceGroupName", newJString(resourceGroupName))
  result = call_564192.call(path_564193, query_564194, nil, nil, nil)

var appServiceEnvironmentsGetDiagnosticsItem* = Call_AppServiceEnvironmentsGetDiagnosticsItem_564183(
    name: "appServiceEnvironmentsGetDiagnosticsItem", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/diagnostics/{diagnosticsName}",
    validator: validate_AppServiceEnvironmentsGetDiagnosticsItem_564184, base: "",
    url: url_AppServiceEnvironmentsGetDiagnosticsItem_564185,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMetricDefinitions_564195 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListMetricDefinitions_564197(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/metricdefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMetricDefinitions_564196(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get global metric definitions of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564198 = path.getOrDefault("name")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "name", valid_564198
  var valid_564199 = path.getOrDefault("subscriptionId")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "subscriptionId", valid_564199
  var valid_564200 = path.getOrDefault("resourceGroupName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "resourceGroupName", valid_564200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564201 = query.getOrDefault("api-version")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "api-version", valid_564201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564202: Call_AppServiceEnvironmentsListMetricDefinitions_564195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get global metric definitions of an App Service Environment.
  ## 
  let valid = call_564202.validator(path, query, header, formData, body)
  let scheme = call_564202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564202.url(scheme.get, call_564202.host, call_564202.base,
                         call_564202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564202, url, valid)

proc call*(call_564203: Call_AppServiceEnvironmentsListMetricDefinitions_564195;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsListMetricDefinitions
  ## Get global metric definitions of an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564204 = newJObject()
  var query_564205 = newJObject()
  add(query_564205, "api-version", newJString(apiVersion))
  add(path_564204, "name", newJString(name))
  add(path_564204, "subscriptionId", newJString(subscriptionId))
  add(path_564204, "resourceGroupName", newJString(resourceGroupName))
  result = call_564203.call(path_564204, query_564205, nil, nil, nil)

var appServiceEnvironmentsListMetricDefinitions* = Call_AppServiceEnvironmentsListMetricDefinitions_564195(
    name: "appServiceEnvironmentsListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/metricdefinitions",
    validator: validate_AppServiceEnvironmentsListMetricDefinitions_564196,
    base: "", url: url_AppServiceEnvironmentsListMetricDefinitions_564197,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMetrics_564206 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListMetrics_564208(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMetrics_564207(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get global metrics of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564210 = path.getOrDefault("name")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "name", valid_564210
  var valid_564211 = path.getOrDefault("subscriptionId")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "subscriptionId", valid_564211
  var valid_564212 = path.getOrDefault("resourceGroupName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "resourceGroupName", valid_564212
  result.add "path", section
  ## parameters in `query` object:
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   api-version: JString (required)
  ##              : API Version
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  var valid_564213 = query.getOrDefault("details")
  valid_564213 = validateParameter(valid_564213, JBool, required = false, default = nil)
  if valid_564213 != nil:
    section.add "details", valid_564213
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564214 = query.getOrDefault("api-version")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "api-version", valid_564214
  var valid_564215 = query.getOrDefault("$filter")
  valid_564215 = validateParameter(valid_564215, JString, required = false,
                                 default = nil)
  if valid_564215 != nil:
    section.add "$filter", valid_564215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564216: Call_AppServiceEnvironmentsListMetrics_564206;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get global metrics of an App Service Environment.
  ## 
  let valid = call_564216.validator(path, query, header, formData, body)
  let scheme = call_564216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564216.url(scheme.get, call_564216.host, call_564216.base,
                         call_564216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564216, url, valid)

proc call*(call_564217: Call_AppServiceEnvironmentsListMetrics_564206;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string; details: bool = false; Filter: string = ""): Recallable =
  ## appServiceEnvironmentsListMetrics
  ## Get global metrics of an App Service Environment.
  ##   details: bool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   Filter: string
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_564218 = newJObject()
  var query_564219 = newJObject()
  add(query_564219, "details", newJBool(details))
  add(query_564219, "api-version", newJString(apiVersion))
  add(path_564218, "name", newJString(name))
  add(path_564218, "subscriptionId", newJString(subscriptionId))
  add(path_564218, "resourceGroupName", newJString(resourceGroupName))
  add(query_564219, "$filter", newJString(Filter))
  result = call_564217.call(path_564218, query_564219, nil, nil, nil)

var appServiceEnvironmentsListMetrics* = Call_AppServiceEnvironmentsListMetrics_564206(
    name: "appServiceEnvironmentsListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/metrics",
    validator: validate_AppServiceEnvironmentsListMetrics_564207, base: "",
    url: url_AppServiceEnvironmentsListMetrics_564208, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePools_564220 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListMultiRolePools_564222(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/multiRolePools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMultiRolePools_564221(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all multi-role pools.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564223 = path.getOrDefault("name")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "name", valid_564223
  var valid_564224 = path.getOrDefault("subscriptionId")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "subscriptionId", valid_564224
  var valid_564225 = path.getOrDefault("resourceGroupName")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "resourceGroupName", valid_564225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564226 = query.getOrDefault("api-version")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "api-version", valid_564226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564227: Call_AppServiceEnvironmentsListMultiRolePools_564220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all multi-role pools.
  ## 
  let valid = call_564227.validator(path, query, header, formData, body)
  let scheme = call_564227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564227.url(scheme.get, call_564227.host, call_564227.base,
                         call_564227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564227, url, valid)

proc call*(call_564228: Call_AppServiceEnvironmentsListMultiRolePools_564220;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsListMultiRolePools
  ## Get all multi-role pools.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564229 = newJObject()
  var query_564230 = newJObject()
  add(query_564230, "api-version", newJString(apiVersion))
  add(path_564229, "name", newJString(name))
  add(path_564229, "subscriptionId", newJString(subscriptionId))
  add(path_564229, "resourceGroupName", newJString(resourceGroupName))
  result = call_564228.call(path_564229, query_564230, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePools* = Call_AppServiceEnvironmentsListMultiRolePools_564220(
    name: "appServiceEnvironmentsListMultiRolePools", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools",
    validator: validate_AppServiceEnvironmentsListMultiRolePools_564221, base: "",
    url: url_AppServiceEnvironmentsListMultiRolePools_564222,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_564242 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_564244(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/multiRolePools/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_564243(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create or update a multi-role pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564245 = path.getOrDefault("name")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "name", valid_564245
  var valid_564246 = path.getOrDefault("subscriptionId")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "subscriptionId", valid_564246
  var valid_564247 = path.getOrDefault("resourceGroupName")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "resourceGroupName", valid_564247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564248 = query.getOrDefault("api-version")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "api-version", valid_564248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   multiRolePoolEnvelope: JObject (required)
  ##                        : Properties of the multi-role pool.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564250: Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_564242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a multi-role pool.
  ## 
  let valid = call_564250.validator(path, query, header, formData, body)
  let scheme = call_564250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564250.url(scheme.get, call_564250.host, call_564250.base,
                         call_564250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564250, url, valid)

proc call*(call_564251: Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_564242;
          apiVersion: string; multiRolePoolEnvelope: JsonNode; name: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsCreateOrUpdateMultiRolePool
  ## Create or update a multi-role pool.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   multiRolePoolEnvelope: JObject (required)
  ##                        : Properties of the multi-role pool.
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564252 = newJObject()
  var query_564253 = newJObject()
  var body_564254 = newJObject()
  add(query_564253, "api-version", newJString(apiVersion))
  if multiRolePoolEnvelope != nil:
    body_564254 = multiRolePoolEnvelope
  add(path_564252, "name", newJString(name))
  add(path_564252, "subscriptionId", newJString(subscriptionId))
  add(path_564252, "resourceGroupName", newJString(resourceGroupName))
  result = call_564251.call(path_564252, query_564253, nil, nil, body_564254)

var appServiceEnvironmentsCreateOrUpdateMultiRolePool* = Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_564242(
    name: "appServiceEnvironmentsCreateOrUpdateMultiRolePool",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default",
    validator: validate_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_564243,
    base: "", url: url_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_564244,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetMultiRolePool_564231 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsGetMultiRolePool_564233(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/multiRolePools/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsGetMultiRolePool_564232(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get properties of a multi-role pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564234 = path.getOrDefault("name")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "name", valid_564234
  var valid_564235 = path.getOrDefault("subscriptionId")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "subscriptionId", valid_564235
  var valid_564236 = path.getOrDefault("resourceGroupName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "resourceGroupName", valid_564236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564237 = query.getOrDefault("api-version")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "api-version", valid_564237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564238: Call_AppServiceEnvironmentsGetMultiRolePool_564231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get properties of a multi-role pool.
  ## 
  let valid = call_564238.validator(path, query, header, formData, body)
  let scheme = call_564238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564238.url(scheme.get, call_564238.host, call_564238.base,
                         call_564238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564238, url, valid)

proc call*(call_564239: Call_AppServiceEnvironmentsGetMultiRolePool_564231;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsGetMultiRolePool
  ## Get properties of a multi-role pool.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564240 = newJObject()
  var query_564241 = newJObject()
  add(query_564241, "api-version", newJString(apiVersion))
  add(path_564240, "name", newJString(name))
  add(path_564240, "subscriptionId", newJString(subscriptionId))
  add(path_564240, "resourceGroupName", newJString(resourceGroupName))
  result = call_564239.call(path_564240, query_564241, nil, nil, nil)

var appServiceEnvironmentsGetMultiRolePool* = Call_AppServiceEnvironmentsGetMultiRolePool_564231(
    name: "appServiceEnvironmentsGetMultiRolePool", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default",
    validator: validate_AppServiceEnvironmentsGetMultiRolePool_564232, base: "",
    url: url_AppServiceEnvironmentsGetMultiRolePool_564233,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsUpdateMultiRolePool_564255 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsUpdateMultiRolePool_564257(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/multiRolePools/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsUpdateMultiRolePool_564256(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a multi-role pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564258 = path.getOrDefault("name")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "name", valid_564258
  var valid_564259 = path.getOrDefault("subscriptionId")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "subscriptionId", valid_564259
  var valid_564260 = path.getOrDefault("resourceGroupName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "resourceGroupName", valid_564260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564261 = query.getOrDefault("api-version")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "api-version", valid_564261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   multiRolePoolEnvelope: JObject (required)
  ##                        : Properties of the multi-role pool.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564263: Call_AppServiceEnvironmentsUpdateMultiRolePool_564255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a multi-role pool.
  ## 
  let valid = call_564263.validator(path, query, header, formData, body)
  let scheme = call_564263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564263.url(scheme.get, call_564263.host, call_564263.base,
                         call_564263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564263, url, valid)

proc call*(call_564264: Call_AppServiceEnvironmentsUpdateMultiRolePool_564255;
          apiVersion: string; multiRolePoolEnvelope: JsonNode; name: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsUpdateMultiRolePool
  ## Create or update a multi-role pool.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   multiRolePoolEnvelope: JObject (required)
  ##                        : Properties of the multi-role pool.
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564265 = newJObject()
  var query_564266 = newJObject()
  var body_564267 = newJObject()
  add(query_564266, "api-version", newJString(apiVersion))
  if multiRolePoolEnvelope != nil:
    body_564267 = multiRolePoolEnvelope
  add(path_564265, "name", newJString(name))
  add(path_564265, "subscriptionId", newJString(subscriptionId))
  add(path_564265, "resourceGroupName", newJString(resourceGroupName))
  result = call_564264.call(path_564265, query_564266, nil, nil, body_564267)

var appServiceEnvironmentsUpdateMultiRolePool* = Call_AppServiceEnvironmentsUpdateMultiRolePool_564255(
    name: "appServiceEnvironmentsUpdateMultiRolePool", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default",
    validator: validate_AppServiceEnvironmentsUpdateMultiRolePool_564256,
    base: "", url: url_AppServiceEnvironmentsUpdateMultiRolePool_564257,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_564268 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_564270(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"), (kind: ConstantSegment,
        value: "/multiRolePools/default/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/metricdefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_564269(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metric definitions for a specific instance of a multi-role pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: JString (required)
  ##           : Name of the instance in the multi-role pool.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564271 = path.getOrDefault("name")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "name", valid_564271
  var valid_564272 = path.getOrDefault("subscriptionId")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "subscriptionId", valid_564272
  var valid_564273 = path.getOrDefault("instance")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "instance", valid_564273
  var valid_564274 = path.getOrDefault("resourceGroupName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "resourceGroupName", valid_564274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564275 = query.getOrDefault("api-version")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "api-version", valid_564275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564276: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_564268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a specific instance of a multi-role pool of an App Service Environment.
  ## 
  let valid = call_564276.validator(path, query, header, formData, body)
  let scheme = call_564276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564276.url(scheme.get, call_564276.host, call_564276.base,
                         call_564276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564276, url, valid)

proc call*(call_564277: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_564268;
          apiVersion: string; name: string; subscriptionId: string; instance: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions
  ## Get metric definitions for a specific instance of a multi-role pool of an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: string (required)
  ##           : Name of the instance in the multi-role pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564278 = newJObject()
  var query_564279 = newJObject()
  add(query_564279, "api-version", newJString(apiVersion))
  add(path_564278, "name", newJString(name))
  add(path_564278, "subscriptionId", newJString(subscriptionId))
  add(path_564278, "instance", newJString(instance))
  add(path_564278, "resourceGroupName", newJString(resourceGroupName))
  result = call_564277.call(path_564278, query_564279, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions* = Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_564268(
    name: "appServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/instances/{instance}/metricdefinitions", validator: validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_564269,
    base: "",
    url: url_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_564270,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_564280 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_564282(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"), (kind: ConstantSegment,
        value: "/multiRolePools/default/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_564281(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metrics for a specific instance of a multi-role pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: JString (required)
  ##           : Name of the instance in the multi-role pool.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564283 = path.getOrDefault("name")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "name", valid_564283
  var valid_564284 = path.getOrDefault("subscriptionId")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "subscriptionId", valid_564284
  var valid_564285 = path.getOrDefault("instance")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "instance", valid_564285
  var valid_564286 = path.getOrDefault("resourceGroupName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "resourceGroupName", valid_564286
  result.add "path", section
  ## parameters in `query` object:
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  var valid_564287 = query.getOrDefault("details")
  valid_564287 = validateParameter(valid_564287, JBool, required = false, default = nil)
  if valid_564287 != nil:
    section.add "details", valid_564287
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564288 = query.getOrDefault("api-version")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "api-version", valid_564288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564289: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_564280;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a specific instance of a multi-role pool of an App Service Environment.
  ## 
  let valid = call_564289.validator(path, query, header, formData, body)
  let scheme = call_564289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564289.url(scheme.get, call_564289.host, call_564289.base,
                         call_564289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564289, url, valid)

proc call*(call_564290: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_564280;
          apiVersion: string; name: string; subscriptionId: string; instance: string;
          resourceGroupName: string; details: bool = false): Recallable =
  ## appServiceEnvironmentsListMultiRolePoolInstanceMetrics
  ## Get metrics for a specific instance of a multi-role pool of an App Service Environment.
  ##   details: bool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: string (required)
  ##           : Name of the instance in the multi-role pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564291 = newJObject()
  var query_564292 = newJObject()
  add(query_564292, "details", newJBool(details))
  add(query_564292, "api-version", newJString(apiVersion))
  add(path_564291, "name", newJString(name))
  add(path_564291, "subscriptionId", newJString(subscriptionId))
  add(path_564291, "instance", newJString(instance))
  add(path_564291, "resourceGroupName", newJString(resourceGroupName))
  result = call_564290.call(path_564291, query_564292, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePoolInstanceMetrics* = Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_564280(
    name: "appServiceEnvironmentsListMultiRolePoolInstanceMetrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/instances/{instance}/metrics",
    validator: validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_564281,
    base: "", url: url_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_564282,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_564293 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListMultiRoleMetricDefinitions_564295(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"), (kind: ConstantSegment,
        value: "/multiRolePools/default/metricdefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMultiRoleMetricDefinitions_564294(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metric definitions for a multi-role pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564296 = path.getOrDefault("name")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "name", valid_564296
  var valid_564297 = path.getOrDefault("subscriptionId")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "subscriptionId", valid_564297
  var valid_564298 = path.getOrDefault("resourceGroupName")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "resourceGroupName", valid_564298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564299 = query.getOrDefault("api-version")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "api-version", valid_564299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564300: Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_564293;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a multi-role pool of an App Service Environment.
  ## 
  let valid = call_564300.validator(path, query, header, formData, body)
  let scheme = call_564300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564300.url(scheme.get, call_564300.host, call_564300.base,
                         call_564300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564300, url, valid)

proc call*(call_564301: Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_564293;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsListMultiRoleMetricDefinitions
  ## Get metric definitions for a multi-role pool of an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564302 = newJObject()
  var query_564303 = newJObject()
  add(query_564303, "api-version", newJString(apiVersion))
  add(path_564302, "name", newJString(name))
  add(path_564302, "subscriptionId", newJString(subscriptionId))
  add(path_564302, "resourceGroupName", newJString(resourceGroupName))
  result = call_564301.call(path_564302, query_564303, nil, nil, nil)

var appServiceEnvironmentsListMultiRoleMetricDefinitions* = Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_564293(
    name: "appServiceEnvironmentsListMultiRoleMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/metricdefinitions",
    validator: validate_AppServiceEnvironmentsListMultiRoleMetricDefinitions_564294,
    base: "", url: url_AppServiceEnvironmentsListMultiRoleMetricDefinitions_564295,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRoleMetrics_564304 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListMultiRoleMetrics_564306(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"), (kind: ConstantSegment,
        value: "/multiRolePools/default/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMultiRoleMetrics_564305(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get metrics for a multi-role pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564307 = path.getOrDefault("name")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "name", valid_564307
  var valid_564308 = path.getOrDefault("subscriptionId")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "subscriptionId", valid_564308
  var valid_564309 = path.getOrDefault("resourceGroupName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "resourceGroupName", valid_564309
  result.add "path", section
  ## parameters in `query` object:
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   api-version: JString (required)
  ##              : API Version
  ##   startTime: JString
  ##            : Beginning time of the metrics query.
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  ##   timeGrain: JString
  ##            : Time granularity of the metrics query.
  ##   endTime: JString
  ##          : End time of the metrics query.
  section = newJObject()
  var valid_564310 = query.getOrDefault("details")
  valid_564310 = validateParameter(valid_564310, JBool, required = false, default = nil)
  if valid_564310 != nil:
    section.add "details", valid_564310
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564311 = query.getOrDefault("api-version")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "api-version", valid_564311
  var valid_564312 = query.getOrDefault("startTime")
  valid_564312 = validateParameter(valid_564312, JString, required = false,
                                 default = nil)
  if valid_564312 != nil:
    section.add "startTime", valid_564312
  var valid_564313 = query.getOrDefault("$filter")
  valid_564313 = validateParameter(valid_564313, JString, required = false,
                                 default = nil)
  if valid_564313 != nil:
    section.add "$filter", valid_564313
  var valid_564314 = query.getOrDefault("timeGrain")
  valid_564314 = validateParameter(valid_564314, JString, required = false,
                                 default = nil)
  if valid_564314 != nil:
    section.add "timeGrain", valid_564314
  var valid_564315 = query.getOrDefault("endTime")
  valid_564315 = validateParameter(valid_564315, JString, required = false,
                                 default = nil)
  if valid_564315 != nil:
    section.add "endTime", valid_564315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564316: Call_AppServiceEnvironmentsListMultiRoleMetrics_564304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a multi-role pool of an App Service Environment.
  ## 
  let valid = call_564316.validator(path, query, header, formData, body)
  let scheme = call_564316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564316.url(scheme.get, call_564316.host, call_564316.base,
                         call_564316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564316, url, valid)

proc call*(call_564317: Call_AppServiceEnvironmentsListMultiRoleMetrics_564304;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string; details: bool = false; startTime: string = "";
          Filter: string = ""; timeGrain: string = ""; endTime: string = ""): Recallable =
  ## appServiceEnvironmentsListMultiRoleMetrics
  ## Get metrics for a multi-role pool of an App Service Environment.
  ##   details: bool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   startTime: string
  ##            : Beginning time of the metrics query.
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   Filter: string
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  ##   timeGrain: string
  ##            : Time granularity of the metrics query.
  ##   endTime: string
  ##          : End time of the metrics query.
  var path_564318 = newJObject()
  var query_564319 = newJObject()
  add(query_564319, "details", newJBool(details))
  add(query_564319, "api-version", newJString(apiVersion))
  add(query_564319, "startTime", newJString(startTime))
  add(path_564318, "name", newJString(name))
  add(path_564318, "subscriptionId", newJString(subscriptionId))
  add(path_564318, "resourceGroupName", newJString(resourceGroupName))
  add(query_564319, "$filter", newJString(Filter))
  add(query_564319, "timeGrain", newJString(timeGrain))
  add(query_564319, "endTime", newJString(endTime))
  result = call_564317.call(path_564318, query_564319, nil, nil, nil)

var appServiceEnvironmentsListMultiRoleMetrics* = Call_AppServiceEnvironmentsListMultiRoleMetrics_564304(
    name: "appServiceEnvironmentsListMultiRoleMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/metrics",
    validator: validate_AppServiceEnvironmentsListMultiRoleMetrics_564305,
    base: "", url: url_AppServiceEnvironmentsListMultiRoleMetrics_564306,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePoolSkus_564320 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListMultiRolePoolSkus_564322(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/multiRolePools/default/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMultiRolePoolSkus_564321(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get available SKUs for scaling a multi-role pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564323 = path.getOrDefault("name")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "name", valid_564323
  var valid_564324 = path.getOrDefault("subscriptionId")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "subscriptionId", valid_564324
  var valid_564325 = path.getOrDefault("resourceGroupName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "resourceGroupName", valid_564325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564326 = query.getOrDefault("api-version")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "api-version", valid_564326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564327: Call_AppServiceEnvironmentsListMultiRolePoolSkus_564320;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get available SKUs for scaling a multi-role pool.
  ## 
  let valid = call_564327.validator(path, query, header, formData, body)
  let scheme = call_564327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564327.url(scheme.get, call_564327.host, call_564327.base,
                         call_564327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564327, url, valid)

proc call*(call_564328: Call_AppServiceEnvironmentsListMultiRolePoolSkus_564320;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsListMultiRolePoolSkus
  ## Get available SKUs for scaling a multi-role pool.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564329 = newJObject()
  var query_564330 = newJObject()
  add(query_564330, "api-version", newJString(apiVersion))
  add(path_564329, "name", newJString(name))
  add(path_564329, "subscriptionId", newJString(subscriptionId))
  add(path_564329, "resourceGroupName", newJString(resourceGroupName))
  result = call_564328.call(path_564329, query_564330, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePoolSkus* = Call_AppServiceEnvironmentsListMultiRolePoolSkus_564320(
    name: "appServiceEnvironmentsListMultiRolePoolSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/skus",
    validator: validate_AppServiceEnvironmentsListMultiRolePoolSkus_564321,
    base: "", url: url_AppServiceEnvironmentsListMultiRolePoolSkus_564322,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRoleUsages_564331 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListMultiRoleUsages_564333(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/multiRolePools/default/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMultiRoleUsages_564332(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get usage metrics for a multi-role pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564334 = path.getOrDefault("name")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "name", valid_564334
  var valid_564335 = path.getOrDefault("subscriptionId")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "subscriptionId", valid_564335
  var valid_564336 = path.getOrDefault("resourceGroupName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "resourceGroupName", valid_564336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564337 = query.getOrDefault("api-version")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "api-version", valid_564337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564338: Call_AppServiceEnvironmentsListMultiRoleUsages_564331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get usage metrics for a multi-role pool of an App Service Environment.
  ## 
  let valid = call_564338.validator(path, query, header, formData, body)
  let scheme = call_564338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564338.url(scheme.get, call_564338.host, call_564338.base,
                         call_564338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564338, url, valid)

proc call*(call_564339: Call_AppServiceEnvironmentsListMultiRoleUsages_564331;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsListMultiRoleUsages
  ## Get usage metrics for a multi-role pool of an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564340 = newJObject()
  var query_564341 = newJObject()
  add(query_564341, "api-version", newJString(apiVersion))
  add(path_564340, "name", newJString(name))
  add(path_564340, "subscriptionId", newJString(subscriptionId))
  add(path_564340, "resourceGroupName", newJString(resourceGroupName))
  result = call_564339.call(path_564340, query_564341, nil, nil, nil)

var appServiceEnvironmentsListMultiRoleUsages* = Call_AppServiceEnvironmentsListMultiRoleUsages_564331(
    name: "appServiceEnvironmentsListMultiRoleUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/usages",
    validator: validate_AppServiceEnvironmentsListMultiRoleUsages_564332,
    base: "", url: url_AppServiceEnvironmentsListMultiRoleUsages_564333,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListOperations_564342 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListOperations_564344(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListOperations_564343(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all currently running operations on the App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564345 = path.getOrDefault("name")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "name", valid_564345
  var valid_564346 = path.getOrDefault("subscriptionId")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "subscriptionId", valid_564346
  var valid_564347 = path.getOrDefault("resourceGroupName")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "resourceGroupName", valid_564347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564348 = query.getOrDefault("api-version")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "api-version", valid_564348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564349: Call_AppServiceEnvironmentsListOperations_564342;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all currently running operations on the App Service Environment.
  ## 
  let valid = call_564349.validator(path, query, header, formData, body)
  let scheme = call_564349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564349.url(scheme.get, call_564349.host, call_564349.base,
                         call_564349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564349, url, valid)

proc call*(call_564350: Call_AppServiceEnvironmentsListOperations_564342;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsListOperations
  ## List all currently running operations on the App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564351 = newJObject()
  var query_564352 = newJObject()
  add(query_564352, "api-version", newJString(apiVersion))
  add(path_564351, "name", newJString(name))
  add(path_564351, "subscriptionId", newJString(subscriptionId))
  add(path_564351, "resourceGroupName", newJString(resourceGroupName))
  result = call_564350.call(path_564351, query_564352, nil, nil, nil)

var appServiceEnvironmentsListOperations* = Call_AppServiceEnvironmentsListOperations_564342(
    name: "appServiceEnvironmentsListOperations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/operations",
    validator: validate_AppServiceEnvironmentsListOperations_564343, base: "",
    url: url_AppServiceEnvironmentsListOperations_564344, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsReboot_564353 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsReboot_564355(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/reboot")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsReboot_564354(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reboot all machines in an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564356 = path.getOrDefault("name")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "name", valid_564356
  var valid_564357 = path.getOrDefault("subscriptionId")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "subscriptionId", valid_564357
  var valid_564358 = path.getOrDefault("resourceGroupName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "resourceGroupName", valid_564358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564359 = query.getOrDefault("api-version")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "api-version", valid_564359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564360: Call_AppServiceEnvironmentsReboot_564353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reboot all machines in an App Service Environment.
  ## 
  let valid = call_564360.validator(path, query, header, formData, body)
  let scheme = call_564360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564360.url(scheme.get, call_564360.host, call_564360.base,
                         call_564360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564360, url, valid)

proc call*(call_564361: Call_AppServiceEnvironmentsReboot_564353;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsReboot
  ## Reboot all machines in an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564362 = newJObject()
  var query_564363 = newJObject()
  add(query_564363, "api-version", newJString(apiVersion))
  add(path_564362, "name", newJString(name))
  add(path_564362, "subscriptionId", newJString(subscriptionId))
  add(path_564362, "resourceGroupName", newJString(resourceGroupName))
  result = call_564361.call(path_564362, query_564363, nil, nil, nil)

var appServiceEnvironmentsReboot* = Call_AppServiceEnvironmentsReboot_564353(
    name: "appServiceEnvironmentsReboot", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/reboot",
    validator: validate_AppServiceEnvironmentsReboot_564354, base: "",
    url: url_AppServiceEnvironmentsReboot_564355, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsResume_564364 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsResume_564366(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/resume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsResume_564365(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resume an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564367 = path.getOrDefault("name")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "name", valid_564367
  var valid_564368 = path.getOrDefault("subscriptionId")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "subscriptionId", valid_564368
  var valid_564369 = path.getOrDefault("resourceGroupName")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "resourceGroupName", valid_564369
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564370 = query.getOrDefault("api-version")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "api-version", valid_564370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564371: Call_AppServiceEnvironmentsResume_564364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume an App Service Environment.
  ## 
  let valid = call_564371.validator(path, query, header, formData, body)
  let scheme = call_564371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564371.url(scheme.get, call_564371.host, call_564371.base,
                         call_564371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564371, url, valid)

proc call*(call_564372: Call_AppServiceEnvironmentsResume_564364;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsResume
  ## Resume an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564373 = newJObject()
  var query_564374 = newJObject()
  add(query_564374, "api-version", newJString(apiVersion))
  add(path_564373, "name", newJString(name))
  add(path_564373, "subscriptionId", newJString(subscriptionId))
  add(path_564373, "resourceGroupName", newJString(resourceGroupName))
  result = call_564372.call(path_564373, query_564374, nil, nil, nil)

var appServiceEnvironmentsResume* = Call_AppServiceEnvironmentsResume_564364(
    name: "appServiceEnvironmentsResume", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/resume",
    validator: validate_AppServiceEnvironmentsResume_564365, base: "",
    url: url_AppServiceEnvironmentsResume_564366, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListAppServicePlans_564375 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListAppServicePlans_564377(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/serverfarms")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListAppServicePlans_564376(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all App Service plans in an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564378 = path.getOrDefault("name")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "name", valid_564378
  var valid_564379 = path.getOrDefault("subscriptionId")
  valid_564379 = validateParameter(valid_564379, JString, required = true,
                                 default = nil)
  if valid_564379 != nil:
    section.add "subscriptionId", valid_564379
  var valid_564380 = path.getOrDefault("resourceGroupName")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "resourceGroupName", valid_564380
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564381 = query.getOrDefault("api-version")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "api-version", valid_564381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564382: Call_AppServiceEnvironmentsListAppServicePlans_564375;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all App Service plans in an App Service Environment.
  ## 
  let valid = call_564382.validator(path, query, header, formData, body)
  let scheme = call_564382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564382.url(scheme.get, call_564382.host, call_564382.base,
                         call_564382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564382, url, valid)

proc call*(call_564383: Call_AppServiceEnvironmentsListAppServicePlans_564375;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsListAppServicePlans
  ## Get all App Service plans in an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564384 = newJObject()
  var query_564385 = newJObject()
  add(query_564385, "api-version", newJString(apiVersion))
  add(path_564384, "name", newJString(name))
  add(path_564384, "subscriptionId", newJString(subscriptionId))
  add(path_564384, "resourceGroupName", newJString(resourceGroupName))
  result = call_564383.call(path_564384, query_564385, nil, nil, nil)

var appServiceEnvironmentsListAppServicePlans* = Call_AppServiceEnvironmentsListAppServicePlans_564375(
    name: "appServiceEnvironmentsListAppServicePlans", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/serverfarms",
    validator: validate_AppServiceEnvironmentsListAppServicePlans_564376,
    base: "", url: url_AppServiceEnvironmentsListAppServicePlans_564377,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebApps_564386 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListWebApps_564388(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/sites")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListWebApps_564387(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all apps in an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564389 = path.getOrDefault("name")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "name", valid_564389
  var valid_564390 = path.getOrDefault("subscriptionId")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "subscriptionId", valid_564390
  var valid_564391 = path.getOrDefault("resourceGroupName")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "resourceGroupName", valid_564391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   propertiesToInclude: JString
  ##                      : Comma separated list of app properties to include.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564392 = query.getOrDefault("api-version")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "api-version", valid_564392
  var valid_564393 = query.getOrDefault("propertiesToInclude")
  valid_564393 = validateParameter(valid_564393, JString, required = false,
                                 default = nil)
  if valid_564393 != nil:
    section.add "propertiesToInclude", valid_564393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564394: Call_AppServiceEnvironmentsListWebApps_564386;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all apps in an App Service Environment.
  ## 
  let valid = call_564394.validator(path, query, header, formData, body)
  let scheme = call_564394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564394.url(scheme.get, call_564394.host, call_564394.base,
                         call_564394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564394, url, valid)

proc call*(call_564395: Call_AppServiceEnvironmentsListWebApps_564386;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string; propertiesToInclude: string = ""): Recallable =
  ## appServiceEnvironmentsListWebApps
  ## Get all apps in an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   propertiesToInclude: string
  ##                      : Comma separated list of app properties to include.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564396 = newJObject()
  var query_564397 = newJObject()
  add(query_564397, "api-version", newJString(apiVersion))
  add(path_564396, "name", newJString(name))
  add(path_564396, "subscriptionId", newJString(subscriptionId))
  add(query_564397, "propertiesToInclude", newJString(propertiesToInclude))
  add(path_564396, "resourceGroupName", newJString(resourceGroupName))
  result = call_564395.call(path_564396, query_564397, nil, nil, nil)

var appServiceEnvironmentsListWebApps* = Call_AppServiceEnvironmentsListWebApps_564386(
    name: "appServiceEnvironmentsListWebApps", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/sites",
    validator: validate_AppServiceEnvironmentsListWebApps_564387, base: "",
    url: url_AppServiceEnvironmentsListWebApps_564388, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsSuspend_564398 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsSuspend_564400(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/suspend")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsSuspend_564399(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Suspend an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564401 = path.getOrDefault("name")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "name", valid_564401
  var valid_564402 = path.getOrDefault("subscriptionId")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "subscriptionId", valid_564402
  var valid_564403 = path.getOrDefault("resourceGroupName")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "resourceGroupName", valid_564403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564404 = query.getOrDefault("api-version")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "api-version", valid_564404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564405: Call_AppServiceEnvironmentsSuspend_564398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspend an App Service Environment.
  ## 
  let valid = call_564405.validator(path, query, header, formData, body)
  let scheme = call_564405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564405.url(scheme.get, call_564405.host, call_564405.base,
                         call_564405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564405, url, valid)

proc call*(call_564406: Call_AppServiceEnvironmentsSuspend_564398;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsSuspend
  ## Suspend an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564407 = newJObject()
  var query_564408 = newJObject()
  add(query_564408, "api-version", newJString(apiVersion))
  add(path_564407, "name", newJString(name))
  add(path_564407, "subscriptionId", newJString(subscriptionId))
  add(path_564407, "resourceGroupName", newJString(resourceGroupName))
  result = call_564406.call(path_564407, query_564408, nil, nil, nil)

var appServiceEnvironmentsSuspend* = Call_AppServiceEnvironmentsSuspend_564398(
    name: "appServiceEnvironmentsSuspend", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/suspend",
    validator: validate_AppServiceEnvironmentsSuspend_564399, base: "",
    url: url_AppServiceEnvironmentsSuspend_564400, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListUsages_564409 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListUsages_564411(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListUsages_564410(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get global usage metrics of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564412 = path.getOrDefault("name")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "name", valid_564412
  var valid_564413 = path.getOrDefault("subscriptionId")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "subscriptionId", valid_564413
  var valid_564414 = path.getOrDefault("resourceGroupName")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "resourceGroupName", valid_564414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564415 = query.getOrDefault("api-version")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "api-version", valid_564415
  var valid_564416 = query.getOrDefault("$filter")
  valid_564416 = validateParameter(valid_564416, JString, required = false,
                                 default = nil)
  if valid_564416 != nil:
    section.add "$filter", valid_564416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564417: Call_AppServiceEnvironmentsListUsages_564409;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get global usage metrics of an App Service Environment.
  ## 
  let valid = call_564417.validator(path, query, header, formData, body)
  let scheme = call_564417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564417.url(scheme.get, call_564417.host, call_564417.base,
                         call_564417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564417, url, valid)

proc call*(call_564418: Call_AppServiceEnvironmentsListUsages_564409;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string; Filter: string = ""): Recallable =
  ## appServiceEnvironmentsListUsages
  ## Get global usage metrics of an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   Filter: string
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_564419 = newJObject()
  var query_564420 = newJObject()
  add(query_564420, "api-version", newJString(apiVersion))
  add(path_564419, "name", newJString(name))
  add(path_564419, "subscriptionId", newJString(subscriptionId))
  add(path_564419, "resourceGroupName", newJString(resourceGroupName))
  add(query_564420, "$filter", newJString(Filter))
  result = call_564418.call(path_564419, query_564420, nil, nil, nil)

var appServiceEnvironmentsListUsages* = Call_AppServiceEnvironmentsListUsages_564409(
    name: "appServiceEnvironmentsListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/usages",
    validator: validate_AppServiceEnvironmentsListUsages_564410, base: "",
    url: url_AppServiceEnvironmentsListUsages_564411, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPools_564421 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListWorkerPools_564423(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListWorkerPools_564422(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all worker pools of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564424 = path.getOrDefault("name")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "name", valid_564424
  var valid_564425 = path.getOrDefault("subscriptionId")
  valid_564425 = validateParameter(valid_564425, JString, required = true,
                                 default = nil)
  if valid_564425 != nil:
    section.add "subscriptionId", valid_564425
  var valid_564426 = path.getOrDefault("resourceGroupName")
  valid_564426 = validateParameter(valid_564426, JString, required = true,
                                 default = nil)
  if valid_564426 != nil:
    section.add "resourceGroupName", valid_564426
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564427 = query.getOrDefault("api-version")
  valid_564427 = validateParameter(valid_564427, JString, required = true,
                                 default = nil)
  if valid_564427 != nil:
    section.add "api-version", valid_564427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564428: Call_AppServiceEnvironmentsListWorkerPools_564421;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all worker pools of an App Service Environment.
  ## 
  let valid = call_564428.validator(path, query, header, formData, body)
  let scheme = call_564428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564428.url(scheme.get, call_564428.host, call_564428.base,
                         call_564428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564428, url, valid)

proc call*(call_564429: Call_AppServiceEnvironmentsListWorkerPools_564421;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsListWorkerPools
  ## Get all worker pools of an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564430 = newJObject()
  var query_564431 = newJObject()
  add(query_564431, "api-version", newJString(apiVersion))
  add(path_564430, "name", newJString(name))
  add(path_564430, "subscriptionId", newJString(subscriptionId))
  add(path_564430, "resourceGroupName", newJString(resourceGroupName))
  result = call_564429.call(path_564430, query_564431, nil, nil, nil)

var appServiceEnvironmentsListWorkerPools* = Call_AppServiceEnvironmentsListWorkerPools_564421(
    name: "appServiceEnvironmentsListWorkerPools", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools",
    validator: validate_AppServiceEnvironmentsListWorkerPools_564422, base: "",
    url: url_AppServiceEnvironmentsListWorkerPools_564423, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_564444 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsCreateOrUpdateWorkerPool_564446(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsCreateOrUpdateWorkerPool_564445(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create or update a worker pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564447 = path.getOrDefault("name")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "name", valid_564447
  var valid_564448 = path.getOrDefault("subscriptionId")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "subscriptionId", valid_564448
  var valid_564449 = path.getOrDefault("resourceGroupName")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "resourceGroupName", valid_564449
  var valid_564450 = path.getOrDefault("workerPoolName")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "workerPoolName", valid_564450
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564451 = query.getOrDefault("api-version")
  valid_564451 = validateParameter(valid_564451, JString, required = true,
                                 default = nil)
  if valid_564451 != nil:
    section.add "api-version", valid_564451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   workerPoolEnvelope: JObject (required)
  ##                     : Properties of the worker pool.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564453: Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_564444;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a worker pool.
  ## 
  let valid = call_564453.validator(path, query, header, formData, body)
  let scheme = call_564453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564453.url(scheme.get, call_564453.host, call_564453.base,
                         call_564453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564453, url, valid)

proc call*(call_564454: Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_564444;
          apiVersion: string; name: string; workerPoolEnvelope: JsonNode;
          subscriptionId: string; resourceGroupName: string; workerPoolName: string): Recallable =
  ## appServiceEnvironmentsCreateOrUpdateWorkerPool
  ## Create or update a worker pool.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolEnvelope: JObject (required)
  ##                     : Properties of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  var path_564455 = newJObject()
  var query_564456 = newJObject()
  var body_564457 = newJObject()
  add(query_564456, "api-version", newJString(apiVersion))
  add(path_564455, "name", newJString(name))
  if workerPoolEnvelope != nil:
    body_564457 = workerPoolEnvelope
  add(path_564455, "subscriptionId", newJString(subscriptionId))
  add(path_564455, "resourceGroupName", newJString(resourceGroupName))
  add(path_564455, "workerPoolName", newJString(workerPoolName))
  result = call_564454.call(path_564455, query_564456, nil, nil, body_564457)

var appServiceEnvironmentsCreateOrUpdateWorkerPool* = Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_564444(
    name: "appServiceEnvironmentsCreateOrUpdateWorkerPool",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}",
    validator: validate_AppServiceEnvironmentsCreateOrUpdateWorkerPool_564445,
    base: "", url: url_AppServiceEnvironmentsCreateOrUpdateWorkerPool_564446,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetWorkerPool_564432 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsGetWorkerPool_564434(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsGetWorkerPool_564433(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get properties of a worker pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564435 = path.getOrDefault("name")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "name", valid_564435
  var valid_564436 = path.getOrDefault("subscriptionId")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "subscriptionId", valid_564436
  var valid_564437 = path.getOrDefault("resourceGroupName")
  valid_564437 = validateParameter(valid_564437, JString, required = true,
                                 default = nil)
  if valid_564437 != nil:
    section.add "resourceGroupName", valid_564437
  var valid_564438 = path.getOrDefault("workerPoolName")
  valid_564438 = validateParameter(valid_564438, JString, required = true,
                                 default = nil)
  if valid_564438 != nil:
    section.add "workerPoolName", valid_564438
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564439 = query.getOrDefault("api-version")
  valid_564439 = validateParameter(valid_564439, JString, required = true,
                                 default = nil)
  if valid_564439 != nil:
    section.add "api-version", valid_564439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564440: Call_AppServiceEnvironmentsGetWorkerPool_564432;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get properties of a worker pool.
  ## 
  let valid = call_564440.validator(path, query, header, formData, body)
  let scheme = call_564440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564440.url(scheme.get, call_564440.host, call_564440.base,
                         call_564440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564440, url, valid)

proc call*(call_564441: Call_AppServiceEnvironmentsGetWorkerPool_564432;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string; workerPoolName: string): Recallable =
  ## appServiceEnvironmentsGetWorkerPool
  ## Get properties of a worker pool.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  var path_564442 = newJObject()
  var query_564443 = newJObject()
  add(query_564443, "api-version", newJString(apiVersion))
  add(path_564442, "name", newJString(name))
  add(path_564442, "subscriptionId", newJString(subscriptionId))
  add(path_564442, "resourceGroupName", newJString(resourceGroupName))
  add(path_564442, "workerPoolName", newJString(workerPoolName))
  result = call_564441.call(path_564442, query_564443, nil, nil, nil)

var appServiceEnvironmentsGetWorkerPool* = Call_AppServiceEnvironmentsGetWorkerPool_564432(
    name: "appServiceEnvironmentsGetWorkerPool", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}",
    validator: validate_AppServiceEnvironmentsGetWorkerPool_564433, base: "",
    url: url_AppServiceEnvironmentsGetWorkerPool_564434, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsUpdateWorkerPool_564458 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsUpdateWorkerPool_564460(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsUpdateWorkerPool_564459(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a worker pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564461 = path.getOrDefault("name")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = nil)
  if valid_564461 != nil:
    section.add "name", valid_564461
  var valid_564462 = path.getOrDefault("subscriptionId")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "subscriptionId", valid_564462
  var valid_564463 = path.getOrDefault("resourceGroupName")
  valid_564463 = validateParameter(valid_564463, JString, required = true,
                                 default = nil)
  if valid_564463 != nil:
    section.add "resourceGroupName", valid_564463
  var valid_564464 = path.getOrDefault("workerPoolName")
  valid_564464 = validateParameter(valid_564464, JString, required = true,
                                 default = nil)
  if valid_564464 != nil:
    section.add "workerPoolName", valid_564464
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564465 = query.getOrDefault("api-version")
  valid_564465 = validateParameter(valid_564465, JString, required = true,
                                 default = nil)
  if valid_564465 != nil:
    section.add "api-version", valid_564465
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   workerPoolEnvelope: JObject (required)
  ##                     : Properties of the worker pool.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564467: Call_AppServiceEnvironmentsUpdateWorkerPool_564458;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a worker pool.
  ## 
  let valid = call_564467.validator(path, query, header, formData, body)
  let scheme = call_564467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564467.url(scheme.get, call_564467.host, call_564467.base,
                         call_564467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564467, url, valid)

proc call*(call_564468: Call_AppServiceEnvironmentsUpdateWorkerPool_564458;
          apiVersion: string; name: string; workerPoolEnvelope: JsonNode;
          subscriptionId: string; resourceGroupName: string; workerPoolName: string): Recallable =
  ## appServiceEnvironmentsUpdateWorkerPool
  ## Create or update a worker pool.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolEnvelope: JObject (required)
  ##                     : Properties of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  var path_564469 = newJObject()
  var query_564470 = newJObject()
  var body_564471 = newJObject()
  add(query_564470, "api-version", newJString(apiVersion))
  add(path_564469, "name", newJString(name))
  if workerPoolEnvelope != nil:
    body_564471 = workerPoolEnvelope
  add(path_564469, "subscriptionId", newJString(subscriptionId))
  add(path_564469, "resourceGroupName", newJString(resourceGroupName))
  add(path_564469, "workerPoolName", newJString(workerPoolName))
  result = call_564468.call(path_564469, query_564470, nil, nil, body_564471)

var appServiceEnvironmentsUpdateWorkerPool* = Call_AppServiceEnvironmentsUpdateWorkerPool_564458(
    name: "appServiceEnvironmentsUpdateWorkerPool", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}",
    validator: validate_AppServiceEnvironmentsUpdateWorkerPool_564459, base: "",
    url: url_AppServiceEnvironmentsUpdateWorkerPool_564460,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_564472 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_564474(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/metricdefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_564473(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metric definitions for a specific instance of a worker pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: JString (required)
  ##           : Name of the instance in the worker pool.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564475 = path.getOrDefault("name")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = nil)
  if valid_564475 != nil:
    section.add "name", valid_564475
  var valid_564476 = path.getOrDefault("subscriptionId")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = nil)
  if valid_564476 != nil:
    section.add "subscriptionId", valid_564476
  var valid_564477 = path.getOrDefault("instance")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "instance", valid_564477
  var valid_564478 = path.getOrDefault("resourceGroupName")
  valid_564478 = validateParameter(valid_564478, JString, required = true,
                                 default = nil)
  if valid_564478 != nil:
    section.add "resourceGroupName", valid_564478
  var valid_564479 = path.getOrDefault("workerPoolName")
  valid_564479 = validateParameter(valid_564479, JString, required = true,
                                 default = nil)
  if valid_564479 != nil:
    section.add "workerPoolName", valid_564479
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564480 = query.getOrDefault("api-version")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "api-version", valid_564480
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564481: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_564472;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a specific instance of a worker pool of an App Service Environment.
  ## 
  let valid = call_564481.validator(path, query, header, formData, body)
  let scheme = call_564481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564481.url(scheme.get, call_564481.host, call_564481.base,
                         call_564481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564481, url, valid)

proc call*(call_564482: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_564472;
          apiVersion: string; name: string; subscriptionId: string; instance: string;
          resourceGroupName: string; workerPoolName: string): Recallable =
  ## appServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions
  ## Get metric definitions for a specific instance of a worker pool of an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: string (required)
  ##           : Name of the instance in the worker pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  var path_564483 = newJObject()
  var query_564484 = newJObject()
  add(query_564484, "api-version", newJString(apiVersion))
  add(path_564483, "name", newJString(name))
  add(path_564483, "subscriptionId", newJString(subscriptionId))
  add(path_564483, "instance", newJString(instance))
  add(path_564483, "resourceGroupName", newJString(resourceGroupName))
  add(path_564483, "workerPoolName", newJString(workerPoolName))
  result = call_564482.call(path_564483, query_564484, nil, nil, nil)

var appServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions* = Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_564472(
    name: "appServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/instances/{instance}/metricdefinitions", validator: validate_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_564473,
    base: "",
    url: url_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_564474,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_564485 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_564487(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_564486(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metrics for a specific instance of a worker pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: JString (required)
  ##           : Name of the instance in the worker pool.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564488 = path.getOrDefault("name")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "name", valid_564488
  var valid_564489 = path.getOrDefault("subscriptionId")
  valid_564489 = validateParameter(valid_564489, JString, required = true,
                                 default = nil)
  if valid_564489 != nil:
    section.add "subscriptionId", valid_564489
  var valid_564490 = path.getOrDefault("instance")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "instance", valid_564490
  var valid_564491 = path.getOrDefault("resourceGroupName")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "resourceGroupName", valid_564491
  var valid_564492 = path.getOrDefault("workerPoolName")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "workerPoolName", valid_564492
  result.add "path", section
  ## parameters in `query` object:
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   api-version: JString (required)
  ##              : API Version
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  var valid_564493 = query.getOrDefault("details")
  valid_564493 = validateParameter(valid_564493, JBool, required = false, default = nil)
  if valid_564493 != nil:
    section.add "details", valid_564493
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564494 = query.getOrDefault("api-version")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = nil)
  if valid_564494 != nil:
    section.add "api-version", valid_564494
  var valid_564495 = query.getOrDefault("$filter")
  valid_564495 = validateParameter(valid_564495, JString, required = false,
                                 default = nil)
  if valid_564495 != nil:
    section.add "$filter", valid_564495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564496: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_564485;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a specific instance of a worker pool of an App Service Environment.
  ## 
  let valid = call_564496.validator(path, query, header, formData, body)
  let scheme = call_564496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564496.url(scheme.get, call_564496.host, call_564496.base,
                         call_564496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564496, url, valid)

proc call*(call_564497: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_564485;
          apiVersion: string; name: string; subscriptionId: string; instance: string;
          resourceGroupName: string; workerPoolName: string; details: bool = false;
          Filter: string = ""): Recallable =
  ## appServiceEnvironmentsListWorkerPoolInstanceMetrics
  ## Get metrics for a specific instance of a worker pool of an App Service Environment.
  ##   details: bool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: string (required)
  ##           : Name of the instance in the worker pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   Filter: string
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  var path_564498 = newJObject()
  var query_564499 = newJObject()
  add(query_564499, "details", newJBool(details))
  add(query_564499, "api-version", newJString(apiVersion))
  add(path_564498, "name", newJString(name))
  add(path_564498, "subscriptionId", newJString(subscriptionId))
  add(path_564498, "instance", newJString(instance))
  add(path_564498, "resourceGroupName", newJString(resourceGroupName))
  add(query_564499, "$filter", newJString(Filter))
  add(path_564498, "workerPoolName", newJString(workerPoolName))
  result = call_564497.call(path_564498, query_564499, nil, nil, nil)

var appServiceEnvironmentsListWorkerPoolInstanceMetrics* = Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_564485(
    name: "appServiceEnvironmentsListWorkerPoolInstanceMetrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/instances/{instance}/metrics",
    validator: validate_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_564486,
    base: "", url: url_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_564487,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_564500 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListWebWorkerMetricDefinitions_564502(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName"),
               (kind: ConstantSegment, value: "/metricdefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListWebWorkerMetricDefinitions_564501(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metric definitions for a worker pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564503 = path.getOrDefault("name")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "name", valid_564503
  var valid_564504 = path.getOrDefault("subscriptionId")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "subscriptionId", valid_564504
  var valid_564505 = path.getOrDefault("resourceGroupName")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "resourceGroupName", valid_564505
  var valid_564506 = path.getOrDefault("workerPoolName")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = nil)
  if valid_564506 != nil:
    section.add "workerPoolName", valid_564506
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564507 = query.getOrDefault("api-version")
  valid_564507 = validateParameter(valid_564507, JString, required = true,
                                 default = nil)
  if valid_564507 != nil:
    section.add "api-version", valid_564507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564508: Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_564500;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a worker pool of an App Service Environment.
  ## 
  let valid = call_564508.validator(path, query, header, formData, body)
  let scheme = call_564508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564508.url(scheme.get, call_564508.host, call_564508.base,
                         call_564508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564508, url, valid)

proc call*(call_564509: Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_564500;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string; workerPoolName: string): Recallable =
  ## appServiceEnvironmentsListWebWorkerMetricDefinitions
  ## Get metric definitions for a worker pool of an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  var path_564510 = newJObject()
  var query_564511 = newJObject()
  add(query_564511, "api-version", newJString(apiVersion))
  add(path_564510, "name", newJString(name))
  add(path_564510, "subscriptionId", newJString(subscriptionId))
  add(path_564510, "resourceGroupName", newJString(resourceGroupName))
  add(path_564510, "workerPoolName", newJString(workerPoolName))
  result = call_564509.call(path_564510, query_564511, nil, nil, nil)

var appServiceEnvironmentsListWebWorkerMetricDefinitions* = Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_564500(
    name: "appServiceEnvironmentsListWebWorkerMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/metricdefinitions",
    validator: validate_AppServiceEnvironmentsListWebWorkerMetricDefinitions_564501,
    base: "", url: url_AppServiceEnvironmentsListWebWorkerMetricDefinitions_564502,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebWorkerMetrics_564512 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListWebWorkerMetrics_564514(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListWebWorkerMetrics_564513(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get metrics for a worker pool of a AppServiceEnvironment (App Service Environment).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   workerPoolName: JString (required)
  ##                 : Name of worker pool
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564515 = path.getOrDefault("name")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "name", valid_564515
  var valid_564516 = path.getOrDefault("subscriptionId")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "subscriptionId", valid_564516
  var valid_564517 = path.getOrDefault("resourceGroupName")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "resourceGroupName", valid_564517
  var valid_564518 = path.getOrDefault("workerPoolName")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "workerPoolName", valid_564518
  result.add "path", section
  ## parameters in `query` object:
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   api-version: JString (required)
  ##              : API Version
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  var valid_564519 = query.getOrDefault("details")
  valid_564519 = validateParameter(valid_564519, JBool, required = false, default = nil)
  if valid_564519 != nil:
    section.add "details", valid_564519
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564520 = query.getOrDefault("api-version")
  valid_564520 = validateParameter(valid_564520, JString, required = true,
                                 default = nil)
  if valid_564520 != nil:
    section.add "api-version", valid_564520
  var valid_564521 = query.getOrDefault("$filter")
  valid_564521 = validateParameter(valid_564521, JString, required = false,
                                 default = nil)
  if valid_564521 != nil:
    section.add "$filter", valid_564521
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564522: Call_AppServiceEnvironmentsListWebWorkerMetrics_564512;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a worker pool of a AppServiceEnvironment (App Service Environment).
  ## 
  let valid = call_564522.validator(path, query, header, formData, body)
  let scheme = call_564522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564522.url(scheme.get, call_564522.host, call_564522.base,
                         call_564522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564522, url, valid)

proc call*(call_564523: Call_AppServiceEnvironmentsListWebWorkerMetrics_564512;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string; workerPoolName: string; details: bool = false;
          Filter: string = ""): Recallable =
  ## appServiceEnvironmentsListWebWorkerMetrics
  ## Get metrics for a worker pool of a AppServiceEnvironment (App Service Environment).
  ##   details: bool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   Filter: string
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  ##   workerPoolName: string (required)
  ##                 : Name of worker pool
  var path_564524 = newJObject()
  var query_564525 = newJObject()
  add(query_564525, "details", newJBool(details))
  add(query_564525, "api-version", newJString(apiVersion))
  add(path_564524, "name", newJString(name))
  add(path_564524, "subscriptionId", newJString(subscriptionId))
  add(path_564524, "resourceGroupName", newJString(resourceGroupName))
  add(query_564525, "$filter", newJString(Filter))
  add(path_564524, "workerPoolName", newJString(workerPoolName))
  result = call_564523.call(path_564524, query_564525, nil, nil, nil)

var appServiceEnvironmentsListWebWorkerMetrics* = Call_AppServiceEnvironmentsListWebWorkerMetrics_564512(
    name: "appServiceEnvironmentsListWebWorkerMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/metrics",
    validator: validate_AppServiceEnvironmentsListWebWorkerMetrics_564513,
    base: "", url: url_AppServiceEnvironmentsListWebWorkerMetrics_564514,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPoolSkus_564526 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListWorkerPoolSkus_564528(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListWorkerPoolSkus_564527(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get available SKUs for scaling a worker pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564529 = path.getOrDefault("name")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "name", valid_564529
  var valid_564530 = path.getOrDefault("subscriptionId")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "subscriptionId", valid_564530
  var valid_564531 = path.getOrDefault("resourceGroupName")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "resourceGroupName", valid_564531
  var valid_564532 = path.getOrDefault("workerPoolName")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "workerPoolName", valid_564532
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564533 = query.getOrDefault("api-version")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "api-version", valid_564533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564534: Call_AppServiceEnvironmentsListWorkerPoolSkus_564526;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get available SKUs for scaling a worker pool.
  ## 
  let valid = call_564534.validator(path, query, header, formData, body)
  let scheme = call_564534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564534.url(scheme.get, call_564534.host, call_564534.base,
                         call_564534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564534, url, valid)

proc call*(call_564535: Call_AppServiceEnvironmentsListWorkerPoolSkus_564526;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string; workerPoolName: string): Recallable =
  ## appServiceEnvironmentsListWorkerPoolSkus
  ## Get available SKUs for scaling a worker pool.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  var path_564536 = newJObject()
  var query_564537 = newJObject()
  add(query_564537, "api-version", newJString(apiVersion))
  add(path_564536, "name", newJString(name))
  add(path_564536, "subscriptionId", newJString(subscriptionId))
  add(path_564536, "resourceGroupName", newJString(resourceGroupName))
  add(path_564536, "workerPoolName", newJString(workerPoolName))
  result = call_564535.call(path_564536, query_564537, nil, nil, nil)

var appServiceEnvironmentsListWorkerPoolSkus* = Call_AppServiceEnvironmentsListWorkerPoolSkus_564526(
    name: "appServiceEnvironmentsListWorkerPoolSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/skus",
    validator: validate_AppServiceEnvironmentsListWorkerPoolSkus_564527, base: "",
    url: url_AppServiceEnvironmentsListWorkerPoolSkus_564528,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebWorkerUsages_564538 = ref object of OpenApiRestCall_563555
proc url_AppServiceEnvironmentsListWebWorkerUsages_564540(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListWebWorkerUsages_564539(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get usage metrics for a worker pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564541 = path.getOrDefault("name")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "name", valid_564541
  var valid_564542 = path.getOrDefault("subscriptionId")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "subscriptionId", valid_564542
  var valid_564543 = path.getOrDefault("resourceGroupName")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "resourceGroupName", valid_564543
  var valid_564544 = path.getOrDefault("workerPoolName")
  valid_564544 = validateParameter(valid_564544, JString, required = true,
                                 default = nil)
  if valid_564544 != nil:
    section.add "workerPoolName", valid_564544
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564545 = query.getOrDefault("api-version")
  valid_564545 = validateParameter(valid_564545, JString, required = true,
                                 default = nil)
  if valid_564545 != nil:
    section.add "api-version", valid_564545
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564546: Call_AppServiceEnvironmentsListWebWorkerUsages_564538;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get usage metrics for a worker pool of an App Service Environment.
  ## 
  let valid = call_564546.validator(path, query, header, formData, body)
  let scheme = call_564546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564546.url(scheme.get, call_564546.host, call_564546.base,
                         call_564546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564546, url, valid)

proc call*(call_564547: Call_AppServiceEnvironmentsListWebWorkerUsages_564538;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string; workerPoolName: string): Recallable =
  ## appServiceEnvironmentsListWebWorkerUsages
  ## Get usage metrics for a worker pool of an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  var path_564548 = newJObject()
  var query_564549 = newJObject()
  add(query_564549, "api-version", newJString(apiVersion))
  add(path_564548, "name", newJString(name))
  add(path_564548, "subscriptionId", newJString(subscriptionId))
  add(path_564548, "resourceGroupName", newJString(resourceGroupName))
  add(path_564548, "workerPoolName", newJString(workerPoolName))
  result = call_564547.call(path_564548, query_564549, nil, nil, nil)

var appServiceEnvironmentsListWebWorkerUsages* = Call_AppServiceEnvironmentsListWebWorkerUsages_564538(
    name: "appServiceEnvironmentsListWebWorkerUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/usages",
    validator: validate_AppServiceEnvironmentsListWebWorkerUsages_564539,
    base: "", url: url_AppServiceEnvironmentsListWebWorkerUsages_564540,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
