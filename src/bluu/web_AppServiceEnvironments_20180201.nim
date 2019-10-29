
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: AppServiceEnvironments API Client
## version: 2018-02-01
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

  OpenApiRestCall_563557 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563557](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563557): Option[Scheme] {.used.} =
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
  Call_AppServiceEnvironmentsList_563779 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsList_563781(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsList_563780(path: JsonNode; query: JsonNode;
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
  var valid_563956 = path.getOrDefault("subscriptionId")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "subscriptionId", valid_563956
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563957 = query.getOrDefault("api-version")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "api-version", valid_563957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563980: Call_AppServiceEnvironmentsList_563779; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all App Service Environments for a subscription.
  ## 
  let valid = call_563980.validator(path, query, header, formData, body)
  let scheme = call_563980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563980.url(scheme.get, call_563980.host, call_563980.base,
                         call_563980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563980, url, valid)

proc call*(call_564051: Call_AppServiceEnvironmentsList_563779; apiVersion: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsList
  ## Get all App Service Environments for a subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_564052 = newJObject()
  var query_564054 = newJObject()
  add(query_564054, "api-version", newJString(apiVersion))
  add(path_564052, "subscriptionId", newJString(subscriptionId))
  result = call_564051.call(path_564052, query_564054, nil, nil, nil)

var appServiceEnvironmentsList* = Call_AppServiceEnvironmentsList_563779(
    name: "appServiceEnvironmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/hostingEnvironments",
    validator: validate_AppServiceEnvironmentsList_563780, base: "",
    url: url_AppServiceEnvironmentsList_563781, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListByResourceGroup_564093 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListByResourceGroup_564095(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListByResourceGroup_564094(path: JsonNode;
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
  var valid_564096 = path.getOrDefault("subscriptionId")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "subscriptionId", valid_564096
  var valid_564097 = path.getOrDefault("resourceGroupName")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "resourceGroupName", valid_564097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564098 = query.getOrDefault("api-version")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "api-version", valid_564098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564099: Call_AppServiceEnvironmentsListByResourceGroup_564093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all App Service Environments in a resource group.
  ## 
  let valid = call_564099.validator(path, query, header, formData, body)
  let scheme = call_564099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564099.url(scheme.get, call_564099.host, call_564099.base,
                         call_564099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564099, url, valid)

proc call*(call_564100: Call_AppServiceEnvironmentsListByResourceGroup_564093;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsListByResourceGroup
  ## Get all App Service Environments in a resource group.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564101 = newJObject()
  var query_564102 = newJObject()
  add(query_564102, "api-version", newJString(apiVersion))
  add(path_564101, "subscriptionId", newJString(subscriptionId))
  add(path_564101, "resourceGroupName", newJString(resourceGroupName))
  result = call_564100.call(path_564101, query_564102, nil, nil, nil)

var appServiceEnvironmentsListByResourceGroup* = Call_AppServiceEnvironmentsListByResourceGroup_564093(
    name: "appServiceEnvironmentsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments",
    validator: validate_AppServiceEnvironmentsListByResourceGroup_564094,
    base: "", url: url_AppServiceEnvironmentsListByResourceGroup_564095,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsCreateOrUpdate_564114 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsCreateOrUpdate_564116(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsCreateOrUpdate_564115(path: JsonNode;
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
  var valid_564117 = path.getOrDefault("name")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "name", valid_564117
  var valid_564118 = path.getOrDefault("subscriptionId")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "subscriptionId", valid_564118
  var valid_564119 = path.getOrDefault("resourceGroupName")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "resourceGroupName", valid_564119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564120 = query.getOrDefault("api-version")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "api-version", valid_564120
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

proc call*(call_564122: Call_AppServiceEnvironmentsCreateOrUpdate_564114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an App Service Environment.
  ## 
  let valid = call_564122.validator(path, query, header, formData, body)
  let scheme = call_564122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564122.url(scheme.get, call_564122.host, call_564122.base,
                         call_564122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564122, url, valid)

proc call*(call_564123: Call_AppServiceEnvironmentsCreateOrUpdate_564114;
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
  var path_564124 = newJObject()
  var query_564125 = newJObject()
  var body_564126 = newJObject()
  add(query_564125, "api-version", newJString(apiVersion))
  add(path_564124, "name", newJString(name))
  add(path_564124, "subscriptionId", newJString(subscriptionId))
  add(path_564124, "resourceGroupName", newJString(resourceGroupName))
  if hostingEnvironmentEnvelope != nil:
    body_564126 = hostingEnvironmentEnvelope
  result = call_564123.call(path_564124, query_564125, nil, nil, body_564126)

var appServiceEnvironmentsCreateOrUpdate* = Call_AppServiceEnvironmentsCreateOrUpdate_564114(
    name: "appServiceEnvironmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsCreateOrUpdate_564115, base: "",
    url: url_AppServiceEnvironmentsCreateOrUpdate_564116, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGet_564103 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsGet_564105(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsGet_564104(path: JsonNode; query: JsonNode;
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
  var valid_564106 = path.getOrDefault("name")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "name", valid_564106
  var valid_564107 = path.getOrDefault("subscriptionId")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "subscriptionId", valid_564107
  var valid_564108 = path.getOrDefault("resourceGroupName")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "resourceGroupName", valid_564108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564109 = query.getOrDefault("api-version")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "api-version", valid_564109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564110: Call_AppServiceEnvironmentsGet_564103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the properties of an App Service Environment.
  ## 
  let valid = call_564110.validator(path, query, header, formData, body)
  let scheme = call_564110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564110.url(scheme.get, call_564110.host, call_564110.base,
                         call_564110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564110, url, valid)

proc call*(call_564111: Call_AppServiceEnvironmentsGet_564103; apiVersion: string;
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
  var path_564112 = newJObject()
  var query_564113 = newJObject()
  add(query_564113, "api-version", newJString(apiVersion))
  add(path_564112, "name", newJString(name))
  add(path_564112, "subscriptionId", newJString(subscriptionId))
  add(path_564112, "resourceGroupName", newJString(resourceGroupName))
  result = call_564111.call(path_564112, query_564113, nil, nil, nil)

var appServiceEnvironmentsGet* = Call_AppServiceEnvironmentsGet_564103(
    name: "appServiceEnvironmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsGet_564104, base: "",
    url: url_AppServiceEnvironmentsGet_564105, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsUpdate_564139 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsUpdate_564141(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsUpdate_564140(path: JsonNode; query: JsonNode;
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
  var valid_564142 = path.getOrDefault("name")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "name", valid_564142
  var valid_564143 = path.getOrDefault("subscriptionId")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "subscriptionId", valid_564143
  var valid_564144 = path.getOrDefault("resourceGroupName")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "resourceGroupName", valid_564144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564145 = query.getOrDefault("api-version")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "api-version", valid_564145
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

proc call*(call_564147: Call_AppServiceEnvironmentsUpdate_564139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an App Service Environment.
  ## 
  let valid = call_564147.validator(path, query, header, formData, body)
  let scheme = call_564147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564147.url(scheme.get, call_564147.host, call_564147.base,
                         call_564147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564147, url, valid)

proc call*(call_564148: Call_AppServiceEnvironmentsUpdate_564139;
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
  var path_564149 = newJObject()
  var query_564150 = newJObject()
  var body_564151 = newJObject()
  add(query_564150, "api-version", newJString(apiVersion))
  add(path_564149, "name", newJString(name))
  add(path_564149, "subscriptionId", newJString(subscriptionId))
  add(path_564149, "resourceGroupName", newJString(resourceGroupName))
  if hostingEnvironmentEnvelope != nil:
    body_564151 = hostingEnvironmentEnvelope
  result = call_564148.call(path_564149, query_564150, nil, nil, body_564151)

var appServiceEnvironmentsUpdate* = Call_AppServiceEnvironmentsUpdate_564139(
    name: "appServiceEnvironmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsUpdate_564140, base: "",
    url: url_AppServiceEnvironmentsUpdate_564141, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsDelete_564127 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsDelete_564129(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsDelete_564128(path: JsonNode; query: JsonNode;
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
  var valid_564130 = path.getOrDefault("name")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "name", valid_564130
  var valid_564131 = path.getOrDefault("subscriptionId")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "subscriptionId", valid_564131
  var valid_564132 = path.getOrDefault("resourceGroupName")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "resourceGroupName", valid_564132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   forceDelete: JBool
  ##              : Specify <code>true</code> to force the deletion even if the App Service Environment contains resources. The default is <code>false</code>.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564133 = query.getOrDefault("api-version")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "api-version", valid_564133
  var valid_564134 = query.getOrDefault("forceDelete")
  valid_564134 = validateParameter(valid_564134, JBool, required = false, default = nil)
  if valid_564134 != nil:
    section.add "forceDelete", valid_564134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564135: Call_AppServiceEnvironmentsDelete_564127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an App Service Environment.
  ## 
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_AppServiceEnvironmentsDelete_564127;
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
  var path_564137 = newJObject()
  var query_564138 = newJObject()
  add(query_564138, "api-version", newJString(apiVersion))
  add(path_564137, "name", newJString(name))
  add(path_564137, "subscriptionId", newJString(subscriptionId))
  add(path_564137, "resourceGroupName", newJString(resourceGroupName))
  add(query_564138, "forceDelete", newJBool(forceDelete))
  result = call_564136.call(path_564137, query_564138, nil, nil, nil)

var appServiceEnvironmentsDelete* = Call_AppServiceEnvironmentsDelete_564127(
    name: "appServiceEnvironmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsDelete_564128, base: "",
    url: url_AppServiceEnvironmentsDelete_564129, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListCapacities_564152 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListCapacities_564154(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListCapacities_564153(path: JsonNode;
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
  var valid_564155 = path.getOrDefault("name")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "name", valid_564155
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
  ##              : API Version
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

proc call*(call_564159: Call_AppServiceEnvironmentsListCapacities_564152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the used, available, and total worker capacity an App Service Environment.
  ## 
  let valid = call_564159.validator(path, query, header, formData, body)
  let scheme = call_564159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564159.url(scheme.get, call_564159.host, call_564159.base,
                         call_564159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564159, url, valid)

proc call*(call_564160: Call_AppServiceEnvironmentsListCapacities_564152;
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
  var path_564161 = newJObject()
  var query_564162 = newJObject()
  add(query_564162, "api-version", newJString(apiVersion))
  add(path_564161, "name", newJString(name))
  add(path_564161, "subscriptionId", newJString(subscriptionId))
  add(path_564161, "resourceGroupName", newJString(resourceGroupName))
  result = call_564160.call(path_564161, query_564162, nil, nil, nil)

var appServiceEnvironmentsListCapacities* = Call_AppServiceEnvironmentsListCapacities_564152(
    name: "appServiceEnvironmentsListCapacities", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/capacities/compute",
    validator: validate_AppServiceEnvironmentsListCapacities_564153, base: "",
    url: url_AppServiceEnvironmentsListCapacities_564154, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListVips_564163 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListVips_564165(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsListVips_564164(path: JsonNode;
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
  var valid_564166 = path.getOrDefault("name")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "name", valid_564166
  var valid_564167 = path.getOrDefault("subscriptionId")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "subscriptionId", valid_564167
  var valid_564168 = path.getOrDefault("resourceGroupName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "resourceGroupName", valid_564168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564169 = query.getOrDefault("api-version")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "api-version", valid_564169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564170: Call_AppServiceEnvironmentsListVips_564163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get IP addresses assigned to an App Service Environment.
  ## 
  let valid = call_564170.validator(path, query, header, formData, body)
  let scheme = call_564170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564170.url(scheme.get, call_564170.host, call_564170.base,
                         call_564170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564170, url, valid)

proc call*(call_564171: Call_AppServiceEnvironmentsListVips_564163;
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
  var path_564172 = newJObject()
  var query_564173 = newJObject()
  add(query_564173, "api-version", newJString(apiVersion))
  add(path_564172, "name", newJString(name))
  add(path_564172, "subscriptionId", newJString(subscriptionId))
  add(path_564172, "resourceGroupName", newJString(resourceGroupName))
  result = call_564171.call(path_564172, query_564173, nil, nil, nil)

var appServiceEnvironmentsListVips* = Call_AppServiceEnvironmentsListVips_564163(
    name: "appServiceEnvironmentsListVips", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/capacities/virtualip",
    validator: validate_AppServiceEnvironmentsListVips_564164, base: "",
    url: url_AppServiceEnvironmentsListVips_564165, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsChangeVnet_564174 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsChangeVnet_564176(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/changeVirtualNetwork")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsChangeVnet_564175(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Move an App Service Environment to a different VNET.
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
  var valid_564177 = path.getOrDefault("name")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "name", valid_564177
  var valid_564178 = path.getOrDefault("subscriptionId")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "subscriptionId", valid_564178
  var valid_564179 = path.getOrDefault("resourceGroupName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "resourceGroupName", valid_564179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564180 = query.getOrDefault("api-version")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "api-version", valid_564180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vnetInfo: JObject (required)
  ##           : Details for the new virtual network.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564182: Call_AppServiceEnvironmentsChangeVnet_564174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Move an App Service Environment to a different VNET.
  ## 
  let valid = call_564182.validator(path, query, header, formData, body)
  let scheme = call_564182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564182.url(scheme.get, call_564182.host, call_564182.base,
                         call_564182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564182, url, valid)

proc call*(call_564183: Call_AppServiceEnvironmentsChangeVnet_564174;
          apiVersion: string; name: string; vnetInfo: JsonNode;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsChangeVnet
  ## Move an App Service Environment to a different VNET.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   vnetInfo: JObject (required)
  ##           : Details for the new virtual network.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564184 = newJObject()
  var query_564185 = newJObject()
  var body_564186 = newJObject()
  add(query_564185, "api-version", newJString(apiVersion))
  add(path_564184, "name", newJString(name))
  if vnetInfo != nil:
    body_564186 = vnetInfo
  add(path_564184, "subscriptionId", newJString(subscriptionId))
  add(path_564184, "resourceGroupName", newJString(resourceGroupName))
  result = call_564183.call(path_564184, query_564185, nil, nil, body_564186)

var appServiceEnvironmentsChangeVnet* = Call_AppServiceEnvironmentsChangeVnet_564174(
    name: "appServiceEnvironmentsChangeVnet", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/changeVirtualNetwork",
    validator: validate_AppServiceEnvironmentsChangeVnet_564175, base: "",
    url: url_AppServiceEnvironmentsChangeVnet_564176, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListDiagnostics_564187 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListDiagnostics_564189(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListDiagnostics_564188(path: JsonNode;
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
  var valid_564190 = path.getOrDefault("name")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "name", valid_564190
  var valid_564191 = path.getOrDefault("subscriptionId")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "subscriptionId", valid_564191
  var valid_564192 = path.getOrDefault("resourceGroupName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "resourceGroupName", valid_564192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564193 = query.getOrDefault("api-version")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "api-version", valid_564193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564194: Call_AppServiceEnvironmentsListDiagnostics_564187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get diagnostic information for an App Service Environment.
  ## 
  let valid = call_564194.validator(path, query, header, formData, body)
  let scheme = call_564194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564194.url(scheme.get, call_564194.host, call_564194.base,
                         call_564194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564194, url, valid)

proc call*(call_564195: Call_AppServiceEnvironmentsListDiagnostics_564187;
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
  var path_564196 = newJObject()
  var query_564197 = newJObject()
  add(query_564197, "api-version", newJString(apiVersion))
  add(path_564196, "name", newJString(name))
  add(path_564196, "subscriptionId", newJString(subscriptionId))
  add(path_564196, "resourceGroupName", newJString(resourceGroupName))
  result = call_564195.call(path_564196, query_564197, nil, nil, nil)

var appServiceEnvironmentsListDiagnostics* = Call_AppServiceEnvironmentsListDiagnostics_564187(
    name: "appServiceEnvironmentsListDiagnostics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/diagnostics",
    validator: validate_AppServiceEnvironmentsListDiagnostics_564188, base: "",
    url: url_AppServiceEnvironmentsListDiagnostics_564189, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetDiagnosticsItem_564198 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsGetDiagnosticsItem_564200(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsGetDiagnosticsItem_564199(path: JsonNode;
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
  var valid_564201 = path.getOrDefault("name")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "name", valid_564201
  var valid_564202 = path.getOrDefault("subscriptionId")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "subscriptionId", valid_564202
  var valid_564203 = path.getOrDefault("diagnosticsName")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "diagnosticsName", valid_564203
  var valid_564204 = path.getOrDefault("resourceGroupName")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "resourceGroupName", valid_564204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564205 = query.getOrDefault("api-version")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "api-version", valid_564205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564206: Call_AppServiceEnvironmentsGetDiagnosticsItem_564198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a diagnostics item for an App Service Environment.
  ## 
  let valid = call_564206.validator(path, query, header, formData, body)
  let scheme = call_564206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564206.url(scheme.get, call_564206.host, call_564206.base,
                         call_564206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564206, url, valid)

proc call*(call_564207: Call_AppServiceEnvironmentsGetDiagnosticsItem_564198;
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
  var path_564208 = newJObject()
  var query_564209 = newJObject()
  add(query_564209, "api-version", newJString(apiVersion))
  add(path_564208, "name", newJString(name))
  add(path_564208, "subscriptionId", newJString(subscriptionId))
  add(path_564208, "diagnosticsName", newJString(diagnosticsName))
  add(path_564208, "resourceGroupName", newJString(resourceGroupName))
  result = call_564207.call(path_564208, query_564209, nil, nil, nil)

var appServiceEnvironmentsGetDiagnosticsItem* = Call_AppServiceEnvironmentsGetDiagnosticsItem_564198(
    name: "appServiceEnvironmentsGetDiagnosticsItem", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/diagnostics/{diagnosticsName}",
    validator: validate_AppServiceEnvironmentsGetDiagnosticsItem_564199, base: "",
    url: url_AppServiceEnvironmentsGetDiagnosticsItem_564200,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_564210 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_564212(
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
        value: "/inboundNetworkDependenciesEndpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_564211(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the network endpoints of all inbound dependencies of an App Service Environment.
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
  var valid_564213 = path.getOrDefault("name")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "name", valid_564213
  var valid_564214 = path.getOrDefault("subscriptionId")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "subscriptionId", valid_564214
  var valid_564215 = path.getOrDefault("resourceGroupName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "resourceGroupName", valid_564215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564216 = query.getOrDefault("api-version")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "api-version", valid_564216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564217: Call_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_564210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the network endpoints of all inbound dependencies of an App Service Environment.
  ## 
  let valid = call_564217.validator(path, query, header, formData, body)
  let scheme = call_564217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564217.url(scheme.get, call_564217.host, call_564217.base,
                         call_564217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564217, url, valid)

proc call*(call_564218: Call_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_564210;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsGetInboundNetworkDependenciesEndpoints
  ## Get the network endpoints of all inbound dependencies of an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564219 = newJObject()
  var query_564220 = newJObject()
  add(query_564220, "api-version", newJString(apiVersion))
  add(path_564219, "name", newJString(name))
  add(path_564219, "subscriptionId", newJString(subscriptionId))
  add(path_564219, "resourceGroupName", newJString(resourceGroupName))
  result = call_564218.call(path_564219, query_564220, nil, nil, nil)

var appServiceEnvironmentsGetInboundNetworkDependenciesEndpoints* = Call_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_564210(
    name: "appServiceEnvironmentsGetInboundNetworkDependenciesEndpoints",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/inboundNetworkDependenciesEndpoints", validator: validate_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_564211,
    base: "",
    url: url_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_564212,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMetricDefinitions_564221 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListMetricDefinitions_564223(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListMetricDefinitions_564222(path: JsonNode;
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
  var valid_564224 = path.getOrDefault("name")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "name", valid_564224
  var valid_564225 = path.getOrDefault("subscriptionId")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "subscriptionId", valid_564225
  var valid_564226 = path.getOrDefault("resourceGroupName")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "resourceGroupName", valid_564226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564227 = query.getOrDefault("api-version")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "api-version", valid_564227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564228: Call_AppServiceEnvironmentsListMetricDefinitions_564221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get global metric definitions of an App Service Environment.
  ## 
  let valid = call_564228.validator(path, query, header, formData, body)
  let scheme = call_564228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564228.url(scheme.get, call_564228.host, call_564228.base,
                         call_564228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564228, url, valid)

proc call*(call_564229: Call_AppServiceEnvironmentsListMetricDefinitions_564221;
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
  var path_564230 = newJObject()
  var query_564231 = newJObject()
  add(query_564231, "api-version", newJString(apiVersion))
  add(path_564230, "name", newJString(name))
  add(path_564230, "subscriptionId", newJString(subscriptionId))
  add(path_564230, "resourceGroupName", newJString(resourceGroupName))
  result = call_564229.call(path_564230, query_564231, nil, nil, nil)

var appServiceEnvironmentsListMetricDefinitions* = Call_AppServiceEnvironmentsListMetricDefinitions_564221(
    name: "appServiceEnvironmentsListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/metricdefinitions",
    validator: validate_AppServiceEnvironmentsListMetricDefinitions_564222,
    base: "", url: url_AppServiceEnvironmentsListMetricDefinitions_564223,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMetrics_564232 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListMetrics_564234(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsListMetrics_564233(path: JsonNode;
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
  var valid_564236 = path.getOrDefault("name")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "name", valid_564236
  var valid_564237 = path.getOrDefault("subscriptionId")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "subscriptionId", valid_564237
  var valid_564238 = path.getOrDefault("resourceGroupName")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "resourceGroupName", valid_564238
  result.add "path", section
  ## parameters in `query` object:
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   api-version: JString (required)
  ##              : API Version
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  var valid_564239 = query.getOrDefault("details")
  valid_564239 = validateParameter(valid_564239, JBool, required = false, default = nil)
  if valid_564239 != nil:
    section.add "details", valid_564239
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564240 = query.getOrDefault("api-version")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "api-version", valid_564240
  var valid_564241 = query.getOrDefault("$filter")
  valid_564241 = validateParameter(valid_564241, JString, required = false,
                                 default = nil)
  if valid_564241 != nil:
    section.add "$filter", valid_564241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564242: Call_AppServiceEnvironmentsListMetrics_564232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get global metrics of an App Service Environment.
  ## 
  let valid = call_564242.validator(path, query, header, formData, body)
  let scheme = call_564242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564242.url(scheme.get, call_564242.host, call_564242.base,
                         call_564242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564242, url, valid)

proc call*(call_564243: Call_AppServiceEnvironmentsListMetrics_564232;
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
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_564244 = newJObject()
  var query_564245 = newJObject()
  add(query_564245, "details", newJBool(details))
  add(query_564245, "api-version", newJString(apiVersion))
  add(path_564244, "name", newJString(name))
  add(path_564244, "subscriptionId", newJString(subscriptionId))
  add(path_564244, "resourceGroupName", newJString(resourceGroupName))
  add(query_564245, "$filter", newJString(Filter))
  result = call_564243.call(path_564244, query_564245, nil, nil, nil)

var appServiceEnvironmentsListMetrics* = Call_AppServiceEnvironmentsListMetrics_564232(
    name: "appServiceEnvironmentsListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/metrics",
    validator: validate_AppServiceEnvironmentsListMetrics_564233, base: "",
    url: url_AppServiceEnvironmentsListMetrics_564234, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePools_564246 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListMultiRolePools_564248(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListMultiRolePools_564247(path: JsonNode;
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
  var valid_564249 = path.getOrDefault("name")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "name", valid_564249
  var valid_564250 = path.getOrDefault("subscriptionId")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "subscriptionId", valid_564250
  var valid_564251 = path.getOrDefault("resourceGroupName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "resourceGroupName", valid_564251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564252 = query.getOrDefault("api-version")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "api-version", valid_564252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564253: Call_AppServiceEnvironmentsListMultiRolePools_564246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all multi-role pools.
  ## 
  let valid = call_564253.validator(path, query, header, formData, body)
  let scheme = call_564253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564253.url(scheme.get, call_564253.host, call_564253.base,
                         call_564253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564253, url, valid)

proc call*(call_564254: Call_AppServiceEnvironmentsListMultiRolePools_564246;
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
  var path_564255 = newJObject()
  var query_564256 = newJObject()
  add(query_564256, "api-version", newJString(apiVersion))
  add(path_564255, "name", newJString(name))
  add(path_564255, "subscriptionId", newJString(subscriptionId))
  add(path_564255, "resourceGroupName", newJString(resourceGroupName))
  result = call_564254.call(path_564255, query_564256, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePools* = Call_AppServiceEnvironmentsListMultiRolePools_564246(
    name: "appServiceEnvironmentsListMultiRolePools", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools",
    validator: validate_AppServiceEnvironmentsListMultiRolePools_564247, base: "",
    url: url_AppServiceEnvironmentsListMultiRolePools_564248,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_564268 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_564270(
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

proc validate_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_564269(
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
  var valid_564273 = path.getOrDefault("resourceGroupName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "resourceGroupName", valid_564273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564274 = query.getOrDefault("api-version")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "api-version", valid_564274
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

proc call*(call_564276: Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_564268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a multi-role pool.
  ## 
  let valid = call_564276.validator(path, query, header, formData, body)
  let scheme = call_564276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564276.url(scheme.get, call_564276.host, call_564276.base,
                         call_564276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564276, url, valid)

proc call*(call_564277: Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_564268;
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
  var path_564278 = newJObject()
  var query_564279 = newJObject()
  var body_564280 = newJObject()
  add(query_564279, "api-version", newJString(apiVersion))
  if multiRolePoolEnvelope != nil:
    body_564280 = multiRolePoolEnvelope
  add(path_564278, "name", newJString(name))
  add(path_564278, "subscriptionId", newJString(subscriptionId))
  add(path_564278, "resourceGroupName", newJString(resourceGroupName))
  result = call_564277.call(path_564278, query_564279, nil, nil, body_564280)

var appServiceEnvironmentsCreateOrUpdateMultiRolePool* = Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_564268(
    name: "appServiceEnvironmentsCreateOrUpdateMultiRolePool",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default",
    validator: validate_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_564269,
    base: "", url: url_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_564270,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetMultiRolePool_564257 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsGetMultiRolePool_564259(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsGetMultiRolePool_564258(path: JsonNode;
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
  var valid_564260 = path.getOrDefault("name")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "name", valid_564260
  var valid_564261 = path.getOrDefault("subscriptionId")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "subscriptionId", valid_564261
  var valid_564262 = path.getOrDefault("resourceGroupName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "resourceGroupName", valid_564262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564263 = query.getOrDefault("api-version")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "api-version", valid_564263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564264: Call_AppServiceEnvironmentsGetMultiRolePool_564257;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get properties of a multi-role pool.
  ## 
  let valid = call_564264.validator(path, query, header, formData, body)
  let scheme = call_564264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564264.url(scheme.get, call_564264.host, call_564264.base,
                         call_564264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564264, url, valid)

proc call*(call_564265: Call_AppServiceEnvironmentsGetMultiRolePool_564257;
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
  var path_564266 = newJObject()
  var query_564267 = newJObject()
  add(query_564267, "api-version", newJString(apiVersion))
  add(path_564266, "name", newJString(name))
  add(path_564266, "subscriptionId", newJString(subscriptionId))
  add(path_564266, "resourceGroupName", newJString(resourceGroupName))
  result = call_564265.call(path_564266, query_564267, nil, nil, nil)

var appServiceEnvironmentsGetMultiRolePool* = Call_AppServiceEnvironmentsGetMultiRolePool_564257(
    name: "appServiceEnvironmentsGetMultiRolePool", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default",
    validator: validate_AppServiceEnvironmentsGetMultiRolePool_564258, base: "",
    url: url_AppServiceEnvironmentsGetMultiRolePool_564259,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsUpdateMultiRolePool_564281 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsUpdateMultiRolePool_564283(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsUpdateMultiRolePool_564282(path: JsonNode;
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
  var valid_564284 = path.getOrDefault("name")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "name", valid_564284
  var valid_564285 = path.getOrDefault("subscriptionId")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "subscriptionId", valid_564285
  var valid_564286 = path.getOrDefault("resourceGroupName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "resourceGroupName", valid_564286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564287 = query.getOrDefault("api-version")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "api-version", valid_564287
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

proc call*(call_564289: Call_AppServiceEnvironmentsUpdateMultiRolePool_564281;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a multi-role pool.
  ## 
  let valid = call_564289.validator(path, query, header, formData, body)
  let scheme = call_564289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564289.url(scheme.get, call_564289.host, call_564289.base,
                         call_564289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564289, url, valid)

proc call*(call_564290: Call_AppServiceEnvironmentsUpdateMultiRolePool_564281;
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
  var path_564291 = newJObject()
  var query_564292 = newJObject()
  var body_564293 = newJObject()
  add(query_564292, "api-version", newJString(apiVersion))
  if multiRolePoolEnvelope != nil:
    body_564293 = multiRolePoolEnvelope
  add(path_564291, "name", newJString(name))
  add(path_564291, "subscriptionId", newJString(subscriptionId))
  add(path_564291, "resourceGroupName", newJString(resourceGroupName))
  result = call_564290.call(path_564291, query_564292, nil, nil, body_564293)

var appServiceEnvironmentsUpdateMultiRolePool* = Call_AppServiceEnvironmentsUpdateMultiRolePool_564281(
    name: "appServiceEnvironmentsUpdateMultiRolePool", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default",
    validator: validate_AppServiceEnvironmentsUpdateMultiRolePool_564282,
    base: "", url: url_AppServiceEnvironmentsUpdateMultiRolePool_564283,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_564294 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_564296(
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

proc validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_564295(
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
  var valid_564297 = path.getOrDefault("name")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "name", valid_564297
  var valid_564298 = path.getOrDefault("subscriptionId")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "subscriptionId", valid_564298
  var valid_564299 = path.getOrDefault("instance")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "instance", valid_564299
  var valid_564300 = path.getOrDefault("resourceGroupName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "resourceGroupName", valid_564300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564301 = query.getOrDefault("api-version")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "api-version", valid_564301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564302: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_564294;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a specific instance of a multi-role pool of an App Service Environment.
  ## 
  let valid = call_564302.validator(path, query, header, formData, body)
  let scheme = call_564302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564302.url(scheme.get, call_564302.host, call_564302.base,
                         call_564302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564302, url, valid)

proc call*(call_564303: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_564294;
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
  var path_564304 = newJObject()
  var query_564305 = newJObject()
  add(query_564305, "api-version", newJString(apiVersion))
  add(path_564304, "name", newJString(name))
  add(path_564304, "subscriptionId", newJString(subscriptionId))
  add(path_564304, "instance", newJString(instance))
  add(path_564304, "resourceGroupName", newJString(resourceGroupName))
  result = call_564303.call(path_564304, query_564305, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions* = Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_564294(
    name: "appServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/instances/{instance}/metricdefinitions", validator: validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_564295,
    base: "",
    url: url_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_564296,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_564306 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_564308(
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

proc validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_564307(
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
  var valid_564309 = path.getOrDefault("name")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "name", valid_564309
  var valid_564310 = path.getOrDefault("subscriptionId")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "subscriptionId", valid_564310
  var valid_564311 = path.getOrDefault("instance")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "instance", valid_564311
  var valid_564312 = path.getOrDefault("resourceGroupName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "resourceGroupName", valid_564312
  result.add "path", section
  ## parameters in `query` object:
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  var valid_564313 = query.getOrDefault("details")
  valid_564313 = validateParameter(valid_564313, JBool, required = false, default = nil)
  if valid_564313 != nil:
    section.add "details", valid_564313
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564314 = query.getOrDefault("api-version")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "api-version", valid_564314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564315: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_564306;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a specific instance of a multi-role pool of an App Service Environment.
  ## 
  let valid = call_564315.validator(path, query, header, formData, body)
  let scheme = call_564315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564315.url(scheme.get, call_564315.host, call_564315.base,
                         call_564315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564315, url, valid)

proc call*(call_564316: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_564306;
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
  var path_564317 = newJObject()
  var query_564318 = newJObject()
  add(query_564318, "details", newJBool(details))
  add(query_564318, "api-version", newJString(apiVersion))
  add(path_564317, "name", newJString(name))
  add(path_564317, "subscriptionId", newJString(subscriptionId))
  add(path_564317, "instance", newJString(instance))
  add(path_564317, "resourceGroupName", newJString(resourceGroupName))
  result = call_564316.call(path_564317, query_564318, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePoolInstanceMetrics* = Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_564306(
    name: "appServiceEnvironmentsListMultiRolePoolInstanceMetrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/instances/{instance}/metrics",
    validator: validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_564307,
    base: "", url: url_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_564308,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_564319 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListMultiRoleMetricDefinitions_564321(
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

proc validate_AppServiceEnvironmentsListMultiRoleMetricDefinitions_564320(
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
  var valid_564322 = path.getOrDefault("name")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "name", valid_564322
  var valid_564323 = path.getOrDefault("subscriptionId")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "subscriptionId", valid_564323
  var valid_564324 = path.getOrDefault("resourceGroupName")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "resourceGroupName", valid_564324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564325 = query.getOrDefault("api-version")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "api-version", valid_564325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564326: Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_564319;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a multi-role pool of an App Service Environment.
  ## 
  let valid = call_564326.validator(path, query, header, formData, body)
  let scheme = call_564326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564326.url(scheme.get, call_564326.host, call_564326.base,
                         call_564326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564326, url, valid)

proc call*(call_564327: Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_564319;
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
  var path_564328 = newJObject()
  var query_564329 = newJObject()
  add(query_564329, "api-version", newJString(apiVersion))
  add(path_564328, "name", newJString(name))
  add(path_564328, "subscriptionId", newJString(subscriptionId))
  add(path_564328, "resourceGroupName", newJString(resourceGroupName))
  result = call_564327.call(path_564328, query_564329, nil, nil, nil)

var appServiceEnvironmentsListMultiRoleMetricDefinitions* = Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_564319(
    name: "appServiceEnvironmentsListMultiRoleMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/metricdefinitions",
    validator: validate_AppServiceEnvironmentsListMultiRoleMetricDefinitions_564320,
    base: "", url: url_AppServiceEnvironmentsListMultiRoleMetricDefinitions_564321,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRoleMetrics_564330 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListMultiRoleMetrics_564332(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListMultiRoleMetrics_564331(path: JsonNode;
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
  var valid_564333 = path.getOrDefault("name")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "name", valid_564333
  var valid_564334 = path.getOrDefault("subscriptionId")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "subscriptionId", valid_564334
  var valid_564335 = path.getOrDefault("resourceGroupName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "resourceGroupName", valid_564335
  result.add "path", section
  ## parameters in `query` object:
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   api-version: JString (required)
  ##              : API Version
  ##   startTime: JString
  ##            : Beginning time of the metrics query.
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  ##   timeGrain: JString
  ##            : Time granularity of the metrics query.
  ##   endTime: JString
  ##          : End time of the metrics query.
  section = newJObject()
  var valid_564336 = query.getOrDefault("details")
  valid_564336 = validateParameter(valid_564336, JBool, required = false, default = nil)
  if valid_564336 != nil:
    section.add "details", valid_564336
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564337 = query.getOrDefault("api-version")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "api-version", valid_564337
  var valid_564338 = query.getOrDefault("startTime")
  valid_564338 = validateParameter(valid_564338, JString, required = false,
                                 default = nil)
  if valid_564338 != nil:
    section.add "startTime", valid_564338
  var valid_564339 = query.getOrDefault("$filter")
  valid_564339 = validateParameter(valid_564339, JString, required = false,
                                 default = nil)
  if valid_564339 != nil:
    section.add "$filter", valid_564339
  var valid_564340 = query.getOrDefault("timeGrain")
  valid_564340 = validateParameter(valid_564340, JString, required = false,
                                 default = nil)
  if valid_564340 != nil:
    section.add "timeGrain", valid_564340
  var valid_564341 = query.getOrDefault("endTime")
  valid_564341 = validateParameter(valid_564341, JString, required = false,
                                 default = nil)
  if valid_564341 != nil:
    section.add "endTime", valid_564341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564342: Call_AppServiceEnvironmentsListMultiRoleMetrics_564330;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a multi-role pool of an App Service Environment.
  ## 
  let valid = call_564342.validator(path, query, header, formData, body)
  let scheme = call_564342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564342.url(scheme.get, call_564342.host, call_564342.base,
                         call_564342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564342, url, valid)

proc call*(call_564343: Call_AppServiceEnvironmentsListMultiRoleMetrics_564330;
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
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  ##   timeGrain: string
  ##            : Time granularity of the metrics query.
  ##   endTime: string
  ##          : End time of the metrics query.
  var path_564344 = newJObject()
  var query_564345 = newJObject()
  add(query_564345, "details", newJBool(details))
  add(query_564345, "api-version", newJString(apiVersion))
  add(query_564345, "startTime", newJString(startTime))
  add(path_564344, "name", newJString(name))
  add(path_564344, "subscriptionId", newJString(subscriptionId))
  add(path_564344, "resourceGroupName", newJString(resourceGroupName))
  add(query_564345, "$filter", newJString(Filter))
  add(query_564345, "timeGrain", newJString(timeGrain))
  add(query_564345, "endTime", newJString(endTime))
  result = call_564343.call(path_564344, query_564345, nil, nil, nil)

var appServiceEnvironmentsListMultiRoleMetrics* = Call_AppServiceEnvironmentsListMultiRoleMetrics_564330(
    name: "appServiceEnvironmentsListMultiRoleMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/metrics",
    validator: validate_AppServiceEnvironmentsListMultiRoleMetrics_564331,
    base: "", url: url_AppServiceEnvironmentsListMultiRoleMetrics_564332,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePoolSkus_564346 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListMultiRolePoolSkus_564348(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListMultiRolePoolSkus_564347(path: JsonNode;
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
  var valid_564349 = path.getOrDefault("name")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "name", valid_564349
  var valid_564350 = path.getOrDefault("subscriptionId")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "subscriptionId", valid_564350
  var valid_564351 = path.getOrDefault("resourceGroupName")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "resourceGroupName", valid_564351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564352 = query.getOrDefault("api-version")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "api-version", valid_564352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564353: Call_AppServiceEnvironmentsListMultiRolePoolSkus_564346;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get available SKUs for scaling a multi-role pool.
  ## 
  let valid = call_564353.validator(path, query, header, formData, body)
  let scheme = call_564353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564353.url(scheme.get, call_564353.host, call_564353.base,
                         call_564353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564353, url, valid)

proc call*(call_564354: Call_AppServiceEnvironmentsListMultiRolePoolSkus_564346;
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
  var path_564355 = newJObject()
  var query_564356 = newJObject()
  add(query_564356, "api-version", newJString(apiVersion))
  add(path_564355, "name", newJString(name))
  add(path_564355, "subscriptionId", newJString(subscriptionId))
  add(path_564355, "resourceGroupName", newJString(resourceGroupName))
  result = call_564354.call(path_564355, query_564356, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePoolSkus* = Call_AppServiceEnvironmentsListMultiRolePoolSkus_564346(
    name: "appServiceEnvironmentsListMultiRolePoolSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/skus",
    validator: validate_AppServiceEnvironmentsListMultiRolePoolSkus_564347,
    base: "", url: url_AppServiceEnvironmentsListMultiRolePoolSkus_564348,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRoleUsages_564357 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListMultiRoleUsages_564359(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListMultiRoleUsages_564358(path: JsonNode;
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
  var valid_564360 = path.getOrDefault("name")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "name", valid_564360
  var valid_564361 = path.getOrDefault("subscriptionId")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "subscriptionId", valid_564361
  var valid_564362 = path.getOrDefault("resourceGroupName")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "resourceGroupName", valid_564362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564363 = query.getOrDefault("api-version")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "api-version", valid_564363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564364: Call_AppServiceEnvironmentsListMultiRoleUsages_564357;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get usage metrics for a multi-role pool of an App Service Environment.
  ## 
  let valid = call_564364.validator(path, query, header, formData, body)
  let scheme = call_564364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564364.url(scheme.get, call_564364.host, call_564364.base,
                         call_564364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564364, url, valid)

proc call*(call_564365: Call_AppServiceEnvironmentsListMultiRoleUsages_564357;
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
  var path_564366 = newJObject()
  var query_564367 = newJObject()
  add(query_564367, "api-version", newJString(apiVersion))
  add(path_564366, "name", newJString(name))
  add(path_564366, "subscriptionId", newJString(subscriptionId))
  add(path_564366, "resourceGroupName", newJString(resourceGroupName))
  result = call_564365.call(path_564366, query_564367, nil, nil, nil)

var appServiceEnvironmentsListMultiRoleUsages* = Call_AppServiceEnvironmentsListMultiRoleUsages_564357(
    name: "appServiceEnvironmentsListMultiRoleUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/usages",
    validator: validate_AppServiceEnvironmentsListMultiRoleUsages_564358,
    base: "", url: url_AppServiceEnvironmentsListMultiRoleUsages_564359,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListOperations_564368 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListOperations_564370(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListOperations_564369(path: JsonNode;
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
  var valid_564371 = path.getOrDefault("name")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "name", valid_564371
  var valid_564372 = path.getOrDefault("subscriptionId")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "subscriptionId", valid_564372
  var valid_564373 = path.getOrDefault("resourceGroupName")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "resourceGroupName", valid_564373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564374 = query.getOrDefault("api-version")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "api-version", valid_564374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564375: Call_AppServiceEnvironmentsListOperations_564368;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all currently running operations on the App Service Environment.
  ## 
  let valid = call_564375.validator(path, query, header, formData, body)
  let scheme = call_564375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564375.url(scheme.get, call_564375.host, call_564375.base,
                         call_564375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564375, url, valid)

proc call*(call_564376: Call_AppServiceEnvironmentsListOperations_564368;
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
  var path_564377 = newJObject()
  var query_564378 = newJObject()
  add(query_564378, "api-version", newJString(apiVersion))
  add(path_564377, "name", newJString(name))
  add(path_564377, "subscriptionId", newJString(subscriptionId))
  add(path_564377, "resourceGroupName", newJString(resourceGroupName))
  result = call_564376.call(path_564377, query_564378, nil, nil, nil)

var appServiceEnvironmentsListOperations* = Call_AppServiceEnvironmentsListOperations_564368(
    name: "appServiceEnvironmentsListOperations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/operations",
    validator: validate_AppServiceEnvironmentsListOperations_564369, base: "",
    url: url_AppServiceEnvironmentsListOperations_564370, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_564379 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_564381(
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
        value: "/outboundNetworkDependenciesEndpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_564380(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the network endpoints of all outbound dependencies of an App Service Environment.
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
  var valid_564382 = path.getOrDefault("name")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "name", valid_564382
  var valid_564383 = path.getOrDefault("subscriptionId")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "subscriptionId", valid_564383
  var valid_564384 = path.getOrDefault("resourceGroupName")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "resourceGroupName", valid_564384
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564385 = query.getOrDefault("api-version")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "api-version", valid_564385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564386: Call_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_564379;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the network endpoints of all outbound dependencies of an App Service Environment.
  ## 
  let valid = call_564386.validator(path, query, header, formData, body)
  let scheme = call_564386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564386.url(scheme.get, call_564386.host, call_564386.base,
                         call_564386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564386, url, valid)

proc call*(call_564387: Call_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_564379;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## appServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints
  ## Get the network endpoints of all outbound dependencies of an App Service Environment.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564388 = newJObject()
  var query_564389 = newJObject()
  add(query_564389, "api-version", newJString(apiVersion))
  add(path_564388, "name", newJString(name))
  add(path_564388, "subscriptionId", newJString(subscriptionId))
  add(path_564388, "resourceGroupName", newJString(resourceGroupName))
  result = call_564387.call(path_564388, query_564389, nil, nil, nil)

var appServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints* = Call_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_564379(
    name: "appServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/outboundNetworkDependenciesEndpoints", validator: validate_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_564380,
    base: "",
    url: url_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_564381,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsReboot_564390 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsReboot_564392(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsReboot_564391(path: JsonNode; query: JsonNode;
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
  var valid_564393 = path.getOrDefault("name")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "name", valid_564393
  var valid_564394 = path.getOrDefault("subscriptionId")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "subscriptionId", valid_564394
  var valid_564395 = path.getOrDefault("resourceGroupName")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "resourceGroupName", valid_564395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564396 = query.getOrDefault("api-version")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "api-version", valid_564396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564397: Call_AppServiceEnvironmentsReboot_564390; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reboot all machines in an App Service Environment.
  ## 
  let valid = call_564397.validator(path, query, header, formData, body)
  let scheme = call_564397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564397.url(scheme.get, call_564397.host, call_564397.base,
                         call_564397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564397, url, valid)

proc call*(call_564398: Call_AppServiceEnvironmentsReboot_564390;
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
  var path_564399 = newJObject()
  var query_564400 = newJObject()
  add(query_564400, "api-version", newJString(apiVersion))
  add(path_564399, "name", newJString(name))
  add(path_564399, "subscriptionId", newJString(subscriptionId))
  add(path_564399, "resourceGroupName", newJString(resourceGroupName))
  result = call_564398.call(path_564399, query_564400, nil, nil, nil)

var appServiceEnvironmentsReboot* = Call_AppServiceEnvironmentsReboot_564390(
    name: "appServiceEnvironmentsReboot", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/reboot",
    validator: validate_AppServiceEnvironmentsReboot_564391, base: "",
    url: url_AppServiceEnvironmentsReboot_564392, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsResume_564401 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsResume_564403(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsResume_564402(path: JsonNode; query: JsonNode;
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
  var valid_564404 = path.getOrDefault("name")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "name", valid_564404
  var valid_564405 = path.getOrDefault("subscriptionId")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "subscriptionId", valid_564405
  var valid_564406 = path.getOrDefault("resourceGroupName")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "resourceGroupName", valid_564406
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564407 = query.getOrDefault("api-version")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "api-version", valid_564407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564408: Call_AppServiceEnvironmentsResume_564401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume an App Service Environment.
  ## 
  let valid = call_564408.validator(path, query, header, formData, body)
  let scheme = call_564408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564408.url(scheme.get, call_564408.host, call_564408.base,
                         call_564408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564408, url, valid)

proc call*(call_564409: Call_AppServiceEnvironmentsResume_564401;
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
  var path_564410 = newJObject()
  var query_564411 = newJObject()
  add(query_564411, "api-version", newJString(apiVersion))
  add(path_564410, "name", newJString(name))
  add(path_564410, "subscriptionId", newJString(subscriptionId))
  add(path_564410, "resourceGroupName", newJString(resourceGroupName))
  result = call_564409.call(path_564410, query_564411, nil, nil, nil)

var appServiceEnvironmentsResume* = Call_AppServiceEnvironmentsResume_564401(
    name: "appServiceEnvironmentsResume", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/resume",
    validator: validate_AppServiceEnvironmentsResume_564402, base: "",
    url: url_AppServiceEnvironmentsResume_564403, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListAppServicePlans_564412 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListAppServicePlans_564414(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListAppServicePlans_564413(path: JsonNode;
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
  var valid_564415 = path.getOrDefault("name")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "name", valid_564415
  var valid_564416 = path.getOrDefault("subscriptionId")
  valid_564416 = validateParameter(valid_564416, JString, required = true,
                                 default = nil)
  if valid_564416 != nil:
    section.add "subscriptionId", valid_564416
  var valid_564417 = path.getOrDefault("resourceGroupName")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "resourceGroupName", valid_564417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564418 = query.getOrDefault("api-version")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "api-version", valid_564418
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564419: Call_AppServiceEnvironmentsListAppServicePlans_564412;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all App Service plans in an App Service Environment.
  ## 
  let valid = call_564419.validator(path, query, header, formData, body)
  let scheme = call_564419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564419.url(scheme.get, call_564419.host, call_564419.base,
                         call_564419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564419, url, valid)

proc call*(call_564420: Call_AppServiceEnvironmentsListAppServicePlans_564412;
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
  var path_564421 = newJObject()
  var query_564422 = newJObject()
  add(query_564422, "api-version", newJString(apiVersion))
  add(path_564421, "name", newJString(name))
  add(path_564421, "subscriptionId", newJString(subscriptionId))
  add(path_564421, "resourceGroupName", newJString(resourceGroupName))
  result = call_564420.call(path_564421, query_564422, nil, nil, nil)

var appServiceEnvironmentsListAppServicePlans* = Call_AppServiceEnvironmentsListAppServicePlans_564412(
    name: "appServiceEnvironmentsListAppServicePlans", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/serverfarms",
    validator: validate_AppServiceEnvironmentsListAppServicePlans_564413,
    base: "", url: url_AppServiceEnvironmentsListAppServicePlans_564414,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebApps_564423 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListWebApps_564425(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsListWebApps_564424(path: JsonNode;
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
  var valid_564426 = path.getOrDefault("name")
  valid_564426 = validateParameter(valid_564426, JString, required = true,
                                 default = nil)
  if valid_564426 != nil:
    section.add "name", valid_564426
  var valid_564427 = path.getOrDefault("subscriptionId")
  valid_564427 = validateParameter(valid_564427, JString, required = true,
                                 default = nil)
  if valid_564427 != nil:
    section.add "subscriptionId", valid_564427
  var valid_564428 = path.getOrDefault("resourceGroupName")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "resourceGroupName", valid_564428
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   propertiesToInclude: JString
  ##                      : Comma separated list of app properties to include.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564429 = query.getOrDefault("api-version")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "api-version", valid_564429
  var valid_564430 = query.getOrDefault("propertiesToInclude")
  valid_564430 = validateParameter(valid_564430, JString, required = false,
                                 default = nil)
  if valid_564430 != nil:
    section.add "propertiesToInclude", valid_564430
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564431: Call_AppServiceEnvironmentsListWebApps_564423;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all apps in an App Service Environment.
  ## 
  let valid = call_564431.validator(path, query, header, formData, body)
  let scheme = call_564431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564431.url(scheme.get, call_564431.host, call_564431.base,
                         call_564431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564431, url, valid)

proc call*(call_564432: Call_AppServiceEnvironmentsListWebApps_564423;
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
  var path_564433 = newJObject()
  var query_564434 = newJObject()
  add(query_564434, "api-version", newJString(apiVersion))
  add(path_564433, "name", newJString(name))
  add(path_564433, "subscriptionId", newJString(subscriptionId))
  add(query_564434, "propertiesToInclude", newJString(propertiesToInclude))
  add(path_564433, "resourceGroupName", newJString(resourceGroupName))
  result = call_564432.call(path_564433, query_564434, nil, nil, nil)

var appServiceEnvironmentsListWebApps* = Call_AppServiceEnvironmentsListWebApps_564423(
    name: "appServiceEnvironmentsListWebApps", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/sites",
    validator: validate_AppServiceEnvironmentsListWebApps_564424, base: "",
    url: url_AppServiceEnvironmentsListWebApps_564425, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsSuspend_564435 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsSuspend_564437(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsSuspend_564436(path: JsonNode; query: JsonNode;
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
  var valid_564438 = path.getOrDefault("name")
  valid_564438 = validateParameter(valid_564438, JString, required = true,
                                 default = nil)
  if valid_564438 != nil:
    section.add "name", valid_564438
  var valid_564439 = path.getOrDefault("subscriptionId")
  valid_564439 = validateParameter(valid_564439, JString, required = true,
                                 default = nil)
  if valid_564439 != nil:
    section.add "subscriptionId", valid_564439
  var valid_564440 = path.getOrDefault("resourceGroupName")
  valid_564440 = validateParameter(valid_564440, JString, required = true,
                                 default = nil)
  if valid_564440 != nil:
    section.add "resourceGroupName", valid_564440
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564441 = query.getOrDefault("api-version")
  valid_564441 = validateParameter(valid_564441, JString, required = true,
                                 default = nil)
  if valid_564441 != nil:
    section.add "api-version", valid_564441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564442: Call_AppServiceEnvironmentsSuspend_564435; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspend an App Service Environment.
  ## 
  let valid = call_564442.validator(path, query, header, formData, body)
  let scheme = call_564442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564442.url(scheme.get, call_564442.host, call_564442.base,
                         call_564442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564442, url, valid)

proc call*(call_564443: Call_AppServiceEnvironmentsSuspend_564435;
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
  var path_564444 = newJObject()
  var query_564445 = newJObject()
  add(query_564445, "api-version", newJString(apiVersion))
  add(path_564444, "name", newJString(name))
  add(path_564444, "subscriptionId", newJString(subscriptionId))
  add(path_564444, "resourceGroupName", newJString(resourceGroupName))
  result = call_564443.call(path_564444, query_564445, nil, nil, nil)

var appServiceEnvironmentsSuspend* = Call_AppServiceEnvironmentsSuspend_564435(
    name: "appServiceEnvironmentsSuspend", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/suspend",
    validator: validate_AppServiceEnvironmentsSuspend_564436, base: "",
    url: url_AppServiceEnvironmentsSuspend_564437, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListUsages_564446 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListUsages_564448(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsListUsages_564447(path: JsonNode;
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
  var valid_564449 = path.getOrDefault("name")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "name", valid_564449
  var valid_564450 = path.getOrDefault("subscriptionId")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "subscriptionId", valid_564450
  var valid_564451 = path.getOrDefault("resourceGroupName")
  valid_564451 = validateParameter(valid_564451, JString, required = true,
                                 default = nil)
  if valid_564451 != nil:
    section.add "resourceGroupName", valid_564451
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564452 = query.getOrDefault("api-version")
  valid_564452 = validateParameter(valid_564452, JString, required = true,
                                 default = nil)
  if valid_564452 != nil:
    section.add "api-version", valid_564452
  var valid_564453 = query.getOrDefault("$filter")
  valid_564453 = validateParameter(valid_564453, JString, required = false,
                                 default = nil)
  if valid_564453 != nil:
    section.add "$filter", valid_564453
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564454: Call_AppServiceEnvironmentsListUsages_564446;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get global usage metrics of an App Service Environment.
  ## 
  let valid = call_564454.validator(path, query, header, formData, body)
  let scheme = call_564454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564454.url(scheme.get, call_564454.host, call_564454.base,
                         call_564454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564454, url, valid)

proc call*(call_564455: Call_AppServiceEnvironmentsListUsages_564446;
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
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_564456 = newJObject()
  var query_564457 = newJObject()
  add(query_564457, "api-version", newJString(apiVersion))
  add(path_564456, "name", newJString(name))
  add(path_564456, "subscriptionId", newJString(subscriptionId))
  add(path_564456, "resourceGroupName", newJString(resourceGroupName))
  add(query_564457, "$filter", newJString(Filter))
  result = call_564455.call(path_564456, query_564457, nil, nil, nil)

var appServiceEnvironmentsListUsages* = Call_AppServiceEnvironmentsListUsages_564446(
    name: "appServiceEnvironmentsListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/usages",
    validator: validate_AppServiceEnvironmentsListUsages_564447, base: "",
    url: url_AppServiceEnvironmentsListUsages_564448, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPools_564458 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListWorkerPools_564460(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListWorkerPools_564459(path: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564464 = query.getOrDefault("api-version")
  valid_564464 = validateParameter(valid_564464, JString, required = true,
                                 default = nil)
  if valid_564464 != nil:
    section.add "api-version", valid_564464
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564465: Call_AppServiceEnvironmentsListWorkerPools_564458;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all worker pools of an App Service Environment.
  ## 
  let valid = call_564465.validator(path, query, header, formData, body)
  let scheme = call_564465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564465.url(scheme.get, call_564465.host, call_564465.base,
                         call_564465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564465, url, valid)

proc call*(call_564466: Call_AppServiceEnvironmentsListWorkerPools_564458;
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
  var path_564467 = newJObject()
  var query_564468 = newJObject()
  add(query_564468, "api-version", newJString(apiVersion))
  add(path_564467, "name", newJString(name))
  add(path_564467, "subscriptionId", newJString(subscriptionId))
  add(path_564467, "resourceGroupName", newJString(resourceGroupName))
  result = call_564466.call(path_564467, query_564468, nil, nil, nil)

var appServiceEnvironmentsListWorkerPools* = Call_AppServiceEnvironmentsListWorkerPools_564458(
    name: "appServiceEnvironmentsListWorkerPools", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools",
    validator: validate_AppServiceEnvironmentsListWorkerPools_564459, base: "",
    url: url_AppServiceEnvironmentsListWorkerPools_564460, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_564481 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsCreateOrUpdateWorkerPool_564483(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsCreateOrUpdateWorkerPool_564482(
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
  var valid_564484 = path.getOrDefault("name")
  valid_564484 = validateParameter(valid_564484, JString, required = true,
                                 default = nil)
  if valid_564484 != nil:
    section.add "name", valid_564484
  var valid_564485 = path.getOrDefault("subscriptionId")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "subscriptionId", valid_564485
  var valid_564486 = path.getOrDefault("resourceGroupName")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "resourceGroupName", valid_564486
  var valid_564487 = path.getOrDefault("workerPoolName")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "workerPoolName", valid_564487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564488 = query.getOrDefault("api-version")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "api-version", valid_564488
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

proc call*(call_564490: Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_564481;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a worker pool.
  ## 
  let valid = call_564490.validator(path, query, header, formData, body)
  let scheme = call_564490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564490.url(scheme.get, call_564490.host, call_564490.base,
                         call_564490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564490, url, valid)

proc call*(call_564491: Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_564481;
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
  var path_564492 = newJObject()
  var query_564493 = newJObject()
  var body_564494 = newJObject()
  add(query_564493, "api-version", newJString(apiVersion))
  add(path_564492, "name", newJString(name))
  if workerPoolEnvelope != nil:
    body_564494 = workerPoolEnvelope
  add(path_564492, "subscriptionId", newJString(subscriptionId))
  add(path_564492, "resourceGroupName", newJString(resourceGroupName))
  add(path_564492, "workerPoolName", newJString(workerPoolName))
  result = call_564491.call(path_564492, query_564493, nil, nil, body_564494)

var appServiceEnvironmentsCreateOrUpdateWorkerPool* = Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_564481(
    name: "appServiceEnvironmentsCreateOrUpdateWorkerPool",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}",
    validator: validate_AppServiceEnvironmentsCreateOrUpdateWorkerPool_564482,
    base: "", url: url_AppServiceEnvironmentsCreateOrUpdateWorkerPool_564483,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetWorkerPool_564469 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsGetWorkerPool_564471(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsGetWorkerPool_564470(path: JsonNode;
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
  var valid_564472 = path.getOrDefault("name")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "name", valid_564472
  var valid_564473 = path.getOrDefault("subscriptionId")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "subscriptionId", valid_564473
  var valid_564474 = path.getOrDefault("resourceGroupName")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "resourceGroupName", valid_564474
  var valid_564475 = path.getOrDefault("workerPoolName")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = nil)
  if valid_564475 != nil:
    section.add "workerPoolName", valid_564475
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564476 = query.getOrDefault("api-version")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = nil)
  if valid_564476 != nil:
    section.add "api-version", valid_564476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564477: Call_AppServiceEnvironmentsGetWorkerPool_564469;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get properties of a worker pool.
  ## 
  let valid = call_564477.validator(path, query, header, formData, body)
  let scheme = call_564477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564477.url(scheme.get, call_564477.host, call_564477.base,
                         call_564477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564477, url, valid)

proc call*(call_564478: Call_AppServiceEnvironmentsGetWorkerPool_564469;
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
  var path_564479 = newJObject()
  var query_564480 = newJObject()
  add(query_564480, "api-version", newJString(apiVersion))
  add(path_564479, "name", newJString(name))
  add(path_564479, "subscriptionId", newJString(subscriptionId))
  add(path_564479, "resourceGroupName", newJString(resourceGroupName))
  add(path_564479, "workerPoolName", newJString(workerPoolName))
  result = call_564478.call(path_564479, query_564480, nil, nil, nil)

var appServiceEnvironmentsGetWorkerPool* = Call_AppServiceEnvironmentsGetWorkerPool_564469(
    name: "appServiceEnvironmentsGetWorkerPool", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}",
    validator: validate_AppServiceEnvironmentsGetWorkerPool_564470, base: "",
    url: url_AppServiceEnvironmentsGetWorkerPool_564471, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsUpdateWorkerPool_564495 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsUpdateWorkerPool_564497(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsUpdateWorkerPool_564496(path: JsonNode;
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
  var valid_564498 = path.getOrDefault("name")
  valid_564498 = validateParameter(valid_564498, JString, required = true,
                                 default = nil)
  if valid_564498 != nil:
    section.add "name", valid_564498
  var valid_564499 = path.getOrDefault("subscriptionId")
  valid_564499 = validateParameter(valid_564499, JString, required = true,
                                 default = nil)
  if valid_564499 != nil:
    section.add "subscriptionId", valid_564499
  var valid_564500 = path.getOrDefault("resourceGroupName")
  valid_564500 = validateParameter(valid_564500, JString, required = true,
                                 default = nil)
  if valid_564500 != nil:
    section.add "resourceGroupName", valid_564500
  var valid_564501 = path.getOrDefault("workerPoolName")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "workerPoolName", valid_564501
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564502 = query.getOrDefault("api-version")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "api-version", valid_564502
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

proc call*(call_564504: Call_AppServiceEnvironmentsUpdateWorkerPool_564495;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a worker pool.
  ## 
  let valid = call_564504.validator(path, query, header, formData, body)
  let scheme = call_564504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564504.url(scheme.get, call_564504.host, call_564504.base,
                         call_564504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564504, url, valid)

proc call*(call_564505: Call_AppServiceEnvironmentsUpdateWorkerPool_564495;
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
  var path_564506 = newJObject()
  var query_564507 = newJObject()
  var body_564508 = newJObject()
  add(query_564507, "api-version", newJString(apiVersion))
  add(path_564506, "name", newJString(name))
  if workerPoolEnvelope != nil:
    body_564508 = workerPoolEnvelope
  add(path_564506, "subscriptionId", newJString(subscriptionId))
  add(path_564506, "resourceGroupName", newJString(resourceGroupName))
  add(path_564506, "workerPoolName", newJString(workerPoolName))
  result = call_564505.call(path_564506, query_564507, nil, nil, body_564508)

var appServiceEnvironmentsUpdateWorkerPool* = Call_AppServiceEnvironmentsUpdateWorkerPool_564495(
    name: "appServiceEnvironmentsUpdateWorkerPool", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}",
    validator: validate_AppServiceEnvironmentsUpdateWorkerPool_564496, base: "",
    url: url_AppServiceEnvironmentsUpdateWorkerPool_564497,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_564509 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_564511(
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

proc validate_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_564510(
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
  var valid_564512 = path.getOrDefault("name")
  valid_564512 = validateParameter(valid_564512, JString, required = true,
                                 default = nil)
  if valid_564512 != nil:
    section.add "name", valid_564512
  var valid_564513 = path.getOrDefault("subscriptionId")
  valid_564513 = validateParameter(valid_564513, JString, required = true,
                                 default = nil)
  if valid_564513 != nil:
    section.add "subscriptionId", valid_564513
  var valid_564514 = path.getOrDefault("instance")
  valid_564514 = validateParameter(valid_564514, JString, required = true,
                                 default = nil)
  if valid_564514 != nil:
    section.add "instance", valid_564514
  var valid_564515 = path.getOrDefault("resourceGroupName")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "resourceGroupName", valid_564515
  var valid_564516 = path.getOrDefault("workerPoolName")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "workerPoolName", valid_564516
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564517 = query.getOrDefault("api-version")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "api-version", valid_564517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564518: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_564509;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a specific instance of a worker pool of an App Service Environment.
  ## 
  let valid = call_564518.validator(path, query, header, formData, body)
  let scheme = call_564518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564518.url(scheme.get, call_564518.host, call_564518.base,
                         call_564518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564518, url, valid)

proc call*(call_564519: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_564509;
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
  var path_564520 = newJObject()
  var query_564521 = newJObject()
  add(query_564521, "api-version", newJString(apiVersion))
  add(path_564520, "name", newJString(name))
  add(path_564520, "subscriptionId", newJString(subscriptionId))
  add(path_564520, "instance", newJString(instance))
  add(path_564520, "resourceGroupName", newJString(resourceGroupName))
  add(path_564520, "workerPoolName", newJString(workerPoolName))
  result = call_564519.call(path_564520, query_564521, nil, nil, nil)

var appServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions* = Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_564509(
    name: "appServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/instances/{instance}/metricdefinitions", validator: validate_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_564510,
    base: "",
    url: url_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_564511,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_564522 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_564524(
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

proc validate_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_564523(
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
  var valid_564525 = path.getOrDefault("name")
  valid_564525 = validateParameter(valid_564525, JString, required = true,
                                 default = nil)
  if valid_564525 != nil:
    section.add "name", valid_564525
  var valid_564526 = path.getOrDefault("subscriptionId")
  valid_564526 = validateParameter(valid_564526, JString, required = true,
                                 default = nil)
  if valid_564526 != nil:
    section.add "subscriptionId", valid_564526
  var valid_564527 = path.getOrDefault("instance")
  valid_564527 = validateParameter(valid_564527, JString, required = true,
                                 default = nil)
  if valid_564527 != nil:
    section.add "instance", valid_564527
  var valid_564528 = path.getOrDefault("resourceGroupName")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "resourceGroupName", valid_564528
  var valid_564529 = path.getOrDefault("workerPoolName")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "workerPoolName", valid_564529
  result.add "path", section
  ## parameters in `query` object:
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   api-version: JString (required)
  ##              : API Version
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  var valid_564530 = query.getOrDefault("details")
  valid_564530 = validateParameter(valid_564530, JBool, required = false, default = nil)
  if valid_564530 != nil:
    section.add "details", valid_564530
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564531 = query.getOrDefault("api-version")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "api-version", valid_564531
  var valid_564532 = query.getOrDefault("$filter")
  valid_564532 = validateParameter(valid_564532, JString, required = false,
                                 default = nil)
  if valid_564532 != nil:
    section.add "$filter", valid_564532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564533: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_564522;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a specific instance of a worker pool of an App Service Environment.
  ## 
  let valid = call_564533.validator(path, query, header, formData, body)
  let scheme = call_564533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564533.url(scheme.get, call_564533.host, call_564533.base,
                         call_564533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564533, url, valid)

proc call*(call_564534: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_564522;
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
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  var path_564535 = newJObject()
  var query_564536 = newJObject()
  add(query_564536, "details", newJBool(details))
  add(query_564536, "api-version", newJString(apiVersion))
  add(path_564535, "name", newJString(name))
  add(path_564535, "subscriptionId", newJString(subscriptionId))
  add(path_564535, "instance", newJString(instance))
  add(path_564535, "resourceGroupName", newJString(resourceGroupName))
  add(query_564536, "$filter", newJString(Filter))
  add(path_564535, "workerPoolName", newJString(workerPoolName))
  result = call_564534.call(path_564535, query_564536, nil, nil, nil)

var appServiceEnvironmentsListWorkerPoolInstanceMetrics* = Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_564522(
    name: "appServiceEnvironmentsListWorkerPoolInstanceMetrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/instances/{instance}/metrics",
    validator: validate_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_564523,
    base: "", url: url_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_564524,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_564537 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListWebWorkerMetricDefinitions_564539(
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

proc validate_AppServiceEnvironmentsListWebWorkerMetricDefinitions_564538(
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
  var valid_564540 = path.getOrDefault("name")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "name", valid_564540
  var valid_564541 = path.getOrDefault("subscriptionId")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "subscriptionId", valid_564541
  var valid_564542 = path.getOrDefault("resourceGroupName")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "resourceGroupName", valid_564542
  var valid_564543 = path.getOrDefault("workerPoolName")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "workerPoolName", valid_564543
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564544 = query.getOrDefault("api-version")
  valid_564544 = validateParameter(valid_564544, JString, required = true,
                                 default = nil)
  if valid_564544 != nil:
    section.add "api-version", valid_564544
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564545: Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_564537;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a worker pool of an App Service Environment.
  ## 
  let valid = call_564545.validator(path, query, header, formData, body)
  let scheme = call_564545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564545.url(scheme.get, call_564545.host, call_564545.base,
                         call_564545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564545, url, valid)

proc call*(call_564546: Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_564537;
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
  var path_564547 = newJObject()
  var query_564548 = newJObject()
  add(query_564548, "api-version", newJString(apiVersion))
  add(path_564547, "name", newJString(name))
  add(path_564547, "subscriptionId", newJString(subscriptionId))
  add(path_564547, "resourceGroupName", newJString(resourceGroupName))
  add(path_564547, "workerPoolName", newJString(workerPoolName))
  result = call_564546.call(path_564547, query_564548, nil, nil, nil)

var appServiceEnvironmentsListWebWorkerMetricDefinitions* = Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_564537(
    name: "appServiceEnvironmentsListWebWorkerMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/metricdefinitions",
    validator: validate_AppServiceEnvironmentsListWebWorkerMetricDefinitions_564538,
    base: "", url: url_AppServiceEnvironmentsListWebWorkerMetricDefinitions_564539,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebWorkerMetrics_564549 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListWebWorkerMetrics_564551(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListWebWorkerMetrics_564550(path: JsonNode;
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
  var valid_564552 = path.getOrDefault("name")
  valid_564552 = validateParameter(valid_564552, JString, required = true,
                                 default = nil)
  if valid_564552 != nil:
    section.add "name", valid_564552
  var valid_564553 = path.getOrDefault("subscriptionId")
  valid_564553 = validateParameter(valid_564553, JString, required = true,
                                 default = nil)
  if valid_564553 != nil:
    section.add "subscriptionId", valid_564553
  var valid_564554 = path.getOrDefault("resourceGroupName")
  valid_564554 = validateParameter(valid_564554, JString, required = true,
                                 default = nil)
  if valid_564554 != nil:
    section.add "resourceGroupName", valid_564554
  var valid_564555 = path.getOrDefault("workerPoolName")
  valid_564555 = validateParameter(valid_564555, JString, required = true,
                                 default = nil)
  if valid_564555 != nil:
    section.add "workerPoolName", valid_564555
  result.add "path", section
  ## parameters in `query` object:
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   api-version: JString (required)
  ##              : API Version
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  var valid_564556 = query.getOrDefault("details")
  valid_564556 = validateParameter(valid_564556, JBool, required = false, default = nil)
  if valid_564556 != nil:
    section.add "details", valid_564556
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564557 = query.getOrDefault("api-version")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "api-version", valid_564557
  var valid_564558 = query.getOrDefault("$filter")
  valid_564558 = validateParameter(valid_564558, JString, required = false,
                                 default = nil)
  if valid_564558 != nil:
    section.add "$filter", valid_564558
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564559: Call_AppServiceEnvironmentsListWebWorkerMetrics_564549;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a worker pool of a AppServiceEnvironment (App Service Environment).
  ## 
  let valid = call_564559.validator(path, query, header, formData, body)
  let scheme = call_564559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564559.url(scheme.get, call_564559.host, call_564559.base,
                         call_564559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564559, url, valid)

proc call*(call_564560: Call_AppServiceEnvironmentsListWebWorkerMetrics_564549;
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
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  ##   workerPoolName: string (required)
  ##                 : Name of worker pool
  var path_564561 = newJObject()
  var query_564562 = newJObject()
  add(query_564562, "details", newJBool(details))
  add(query_564562, "api-version", newJString(apiVersion))
  add(path_564561, "name", newJString(name))
  add(path_564561, "subscriptionId", newJString(subscriptionId))
  add(path_564561, "resourceGroupName", newJString(resourceGroupName))
  add(query_564562, "$filter", newJString(Filter))
  add(path_564561, "workerPoolName", newJString(workerPoolName))
  result = call_564560.call(path_564561, query_564562, nil, nil, nil)

var appServiceEnvironmentsListWebWorkerMetrics* = Call_AppServiceEnvironmentsListWebWorkerMetrics_564549(
    name: "appServiceEnvironmentsListWebWorkerMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/metrics",
    validator: validate_AppServiceEnvironmentsListWebWorkerMetrics_564550,
    base: "", url: url_AppServiceEnvironmentsListWebWorkerMetrics_564551,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPoolSkus_564563 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListWorkerPoolSkus_564565(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListWorkerPoolSkus_564564(path: JsonNode;
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
  var valid_564566 = path.getOrDefault("name")
  valid_564566 = validateParameter(valid_564566, JString, required = true,
                                 default = nil)
  if valid_564566 != nil:
    section.add "name", valid_564566
  var valid_564567 = path.getOrDefault("subscriptionId")
  valid_564567 = validateParameter(valid_564567, JString, required = true,
                                 default = nil)
  if valid_564567 != nil:
    section.add "subscriptionId", valid_564567
  var valid_564568 = path.getOrDefault("resourceGroupName")
  valid_564568 = validateParameter(valid_564568, JString, required = true,
                                 default = nil)
  if valid_564568 != nil:
    section.add "resourceGroupName", valid_564568
  var valid_564569 = path.getOrDefault("workerPoolName")
  valid_564569 = validateParameter(valid_564569, JString, required = true,
                                 default = nil)
  if valid_564569 != nil:
    section.add "workerPoolName", valid_564569
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564570 = query.getOrDefault("api-version")
  valid_564570 = validateParameter(valid_564570, JString, required = true,
                                 default = nil)
  if valid_564570 != nil:
    section.add "api-version", valid_564570
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564571: Call_AppServiceEnvironmentsListWorkerPoolSkus_564563;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get available SKUs for scaling a worker pool.
  ## 
  let valid = call_564571.validator(path, query, header, formData, body)
  let scheme = call_564571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564571.url(scheme.get, call_564571.host, call_564571.base,
                         call_564571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564571, url, valid)

proc call*(call_564572: Call_AppServiceEnvironmentsListWorkerPoolSkus_564563;
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
  var path_564573 = newJObject()
  var query_564574 = newJObject()
  add(query_564574, "api-version", newJString(apiVersion))
  add(path_564573, "name", newJString(name))
  add(path_564573, "subscriptionId", newJString(subscriptionId))
  add(path_564573, "resourceGroupName", newJString(resourceGroupName))
  add(path_564573, "workerPoolName", newJString(workerPoolName))
  result = call_564572.call(path_564573, query_564574, nil, nil, nil)

var appServiceEnvironmentsListWorkerPoolSkus* = Call_AppServiceEnvironmentsListWorkerPoolSkus_564563(
    name: "appServiceEnvironmentsListWorkerPoolSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/skus",
    validator: validate_AppServiceEnvironmentsListWorkerPoolSkus_564564, base: "",
    url: url_AppServiceEnvironmentsListWorkerPoolSkus_564565,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebWorkerUsages_564575 = ref object of OpenApiRestCall_563557
proc url_AppServiceEnvironmentsListWebWorkerUsages_564577(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListWebWorkerUsages_564576(path: JsonNode;
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
  var valid_564578 = path.getOrDefault("name")
  valid_564578 = validateParameter(valid_564578, JString, required = true,
                                 default = nil)
  if valid_564578 != nil:
    section.add "name", valid_564578
  var valid_564579 = path.getOrDefault("subscriptionId")
  valid_564579 = validateParameter(valid_564579, JString, required = true,
                                 default = nil)
  if valid_564579 != nil:
    section.add "subscriptionId", valid_564579
  var valid_564580 = path.getOrDefault("resourceGroupName")
  valid_564580 = validateParameter(valid_564580, JString, required = true,
                                 default = nil)
  if valid_564580 != nil:
    section.add "resourceGroupName", valid_564580
  var valid_564581 = path.getOrDefault("workerPoolName")
  valid_564581 = validateParameter(valid_564581, JString, required = true,
                                 default = nil)
  if valid_564581 != nil:
    section.add "workerPoolName", valid_564581
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564582 = query.getOrDefault("api-version")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "api-version", valid_564582
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564583: Call_AppServiceEnvironmentsListWebWorkerUsages_564575;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get usage metrics for a worker pool of an App Service Environment.
  ## 
  let valid = call_564583.validator(path, query, header, formData, body)
  let scheme = call_564583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564583.url(scheme.get, call_564583.host, call_564583.base,
                         call_564583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564583, url, valid)

proc call*(call_564584: Call_AppServiceEnvironmentsListWebWorkerUsages_564575;
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
  var path_564585 = newJObject()
  var query_564586 = newJObject()
  add(query_564586, "api-version", newJString(apiVersion))
  add(path_564585, "name", newJString(name))
  add(path_564585, "subscriptionId", newJString(subscriptionId))
  add(path_564585, "resourceGroupName", newJString(resourceGroupName))
  add(path_564585, "workerPoolName", newJString(workerPoolName))
  result = call_564584.call(path_564585, query_564586, nil, nil, nil)

var appServiceEnvironmentsListWebWorkerUsages* = Call_AppServiceEnvironmentsListWebWorkerUsages_564575(
    name: "appServiceEnvironmentsListWebWorkerUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/usages",
    validator: validate_AppServiceEnvironmentsListWebWorkerUsages_564576,
    base: "", url: url_AppServiceEnvironmentsListWebWorkerUsages_564577,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
