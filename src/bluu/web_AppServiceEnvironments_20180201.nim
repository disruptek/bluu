
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567659 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567659](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567659): Option[Scheme] {.used.} =
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
  macServiceName = "web-AppServiceEnvironments"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppServiceEnvironmentsList_567881 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsList_567883(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsList_567882(path: JsonNode; query: JsonNode;
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
  var valid_568056 = path.getOrDefault("subscriptionId")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "subscriptionId", valid_568056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568057 = query.getOrDefault("api-version")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "api-version", valid_568057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568080: Call_AppServiceEnvironmentsList_567881; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all App Service Environments for a subscription.
  ## 
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_AppServiceEnvironmentsList_567881; apiVersion: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsList
  ## Get all App Service Environments for a subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568152 = newJObject()
  var query_568154 = newJObject()
  add(query_568154, "api-version", newJString(apiVersion))
  add(path_568152, "subscriptionId", newJString(subscriptionId))
  result = call_568151.call(path_568152, query_568154, nil, nil, nil)

var appServiceEnvironmentsList* = Call_AppServiceEnvironmentsList_567881(
    name: "appServiceEnvironmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/hostingEnvironments",
    validator: validate_AppServiceEnvironmentsList_567882, base: "",
    url: url_AppServiceEnvironmentsList_567883, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListByResourceGroup_568193 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListByResourceGroup_568195(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListByResourceGroup_568194(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all App Service Environments in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568196 = path.getOrDefault("resourceGroupName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "resourceGroupName", valid_568196
  var valid_568197 = path.getOrDefault("subscriptionId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "subscriptionId", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
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

proc call*(call_568199: Call_AppServiceEnvironmentsListByResourceGroup_568193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all App Service Environments in a resource group.
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_AppServiceEnvironmentsListByResourceGroup_568193;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListByResourceGroup
  ## Get all App Service Environments in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568201 = newJObject()
  var query_568202 = newJObject()
  add(path_568201, "resourceGroupName", newJString(resourceGroupName))
  add(query_568202, "api-version", newJString(apiVersion))
  add(path_568201, "subscriptionId", newJString(subscriptionId))
  result = call_568200.call(path_568201, query_568202, nil, nil, nil)

var appServiceEnvironmentsListByResourceGroup* = Call_AppServiceEnvironmentsListByResourceGroup_568193(
    name: "appServiceEnvironmentsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments",
    validator: validate_AppServiceEnvironmentsListByResourceGroup_568194,
    base: "", url: url_AppServiceEnvironmentsListByResourceGroup_568195,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsCreateOrUpdate_568214 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsCreateOrUpdate_568216(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsCreateOrUpdate_568215(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568217 = path.getOrDefault("resourceGroupName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "resourceGroupName", valid_568217
  var valid_568218 = path.getOrDefault("name")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "name", valid_568218
  var valid_568219 = path.getOrDefault("subscriptionId")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "subscriptionId", valid_568219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568220 = query.getOrDefault("api-version")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "api-version", valid_568220
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

proc call*(call_568222: Call_AppServiceEnvironmentsCreateOrUpdate_568214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an App Service Environment.
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_AppServiceEnvironmentsCreateOrUpdate_568214;
          resourceGroupName: string; apiVersion: string; name: string;
          hostingEnvironmentEnvelope: JsonNode; subscriptionId: string): Recallable =
  ## appServiceEnvironmentsCreateOrUpdate
  ## Create or update an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   hostingEnvironmentEnvelope: JObject (required)
  ##                             : Configuration details of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  var body_568226 = newJObject()
  add(path_568224, "resourceGroupName", newJString(resourceGroupName))
  add(query_568225, "api-version", newJString(apiVersion))
  add(path_568224, "name", newJString(name))
  if hostingEnvironmentEnvelope != nil:
    body_568226 = hostingEnvironmentEnvelope
  add(path_568224, "subscriptionId", newJString(subscriptionId))
  result = call_568223.call(path_568224, query_568225, nil, nil, body_568226)

var appServiceEnvironmentsCreateOrUpdate* = Call_AppServiceEnvironmentsCreateOrUpdate_568214(
    name: "appServiceEnvironmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsCreateOrUpdate_568215, base: "",
    url: url_AppServiceEnvironmentsCreateOrUpdate_568216, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGet_568203 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsGet_568205(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsGet_568204(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the properties of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568206 = path.getOrDefault("resourceGroupName")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "resourceGroupName", valid_568206
  var valid_568207 = path.getOrDefault("name")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "name", valid_568207
  var valid_568208 = path.getOrDefault("subscriptionId")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "subscriptionId", valid_568208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568209 = query.getOrDefault("api-version")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "api-version", valid_568209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568210: Call_AppServiceEnvironmentsGet_568203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the properties of an App Service Environment.
  ## 
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_AppServiceEnvironmentsGet_568203;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsGet
  ## Get the properties of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568212 = newJObject()
  var query_568213 = newJObject()
  add(path_568212, "resourceGroupName", newJString(resourceGroupName))
  add(query_568213, "api-version", newJString(apiVersion))
  add(path_568212, "name", newJString(name))
  add(path_568212, "subscriptionId", newJString(subscriptionId))
  result = call_568211.call(path_568212, query_568213, nil, nil, nil)

var appServiceEnvironmentsGet* = Call_AppServiceEnvironmentsGet_568203(
    name: "appServiceEnvironmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsGet_568204, base: "",
    url: url_AppServiceEnvironmentsGet_568205, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsUpdate_568239 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsUpdate_568241(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsUpdate_568240(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568242 = path.getOrDefault("resourceGroupName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "resourceGroupName", valid_568242
  var valid_568243 = path.getOrDefault("name")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "name", valid_568243
  var valid_568244 = path.getOrDefault("subscriptionId")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "subscriptionId", valid_568244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568245 = query.getOrDefault("api-version")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "api-version", valid_568245
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

proc call*(call_568247: Call_AppServiceEnvironmentsUpdate_568239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an App Service Environment.
  ## 
  let valid = call_568247.validator(path, query, header, formData, body)
  let scheme = call_568247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568247.url(scheme.get, call_568247.host, call_568247.base,
                         call_568247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568247, url, valid)

proc call*(call_568248: Call_AppServiceEnvironmentsUpdate_568239;
          resourceGroupName: string; apiVersion: string; name: string;
          hostingEnvironmentEnvelope: JsonNode; subscriptionId: string): Recallable =
  ## appServiceEnvironmentsUpdate
  ## Create or update an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   hostingEnvironmentEnvelope: JObject (required)
  ##                             : Configuration details of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568249 = newJObject()
  var query_568250 = newJObject()
  var body_568251 = newJObject()
  add(path_568249, "resourceGroupName", newJString(resourceGroupName))
  add(query_568250, "api-version", newJString(apiVersion))
  add(path_568249, "name", newJString(name))
  if hostingEnvironmentEnvelope != nil:
    body_568251 = hostingEnvironmentEnvelope
  add(path_568249, "subscriptionId", newJString(subscriptionId))
  result = call_568248.call(path_568249, query_568250, nil, nil, body_568251)

var appServiceEnvironmentsUpdate* = Call_AppServiceEnvironmentsUpdate_568239(
    name: "appServiceEnvironmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsUpdate_568240, base: "",
    url: url_AppServiceEnvironmentsUpdate_568241, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsDelete_568227 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsDelete_568229(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsDelete_568228(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568230 = path.getOrDefault("resourceGroupName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "resourceGroupName", valid_568230
  var valid_568231 = path.getOrDefault("name")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "name", valid_568231
  var valid_568232 = path.getOrDefault("subscriptionId")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "subscriptionId", valid_568232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   forceDelete: JBool
  ##              : Specify <code>true</code> to force the deletion even if the App Service Environment contains resources. The default is <code>false</code>.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568233 = query.getOrDefault("api-version")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "api-version", valid_568233
  var valid_568234 = query.getOrDefault("forceDelete")
  valid_568234 = validateParameter(valid_568234, JBool, required = false, default = nil)
  if valid_568234 != nil:
    section.add "forceDelete", valid_568234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568235: Call_AppServiceEnvironmentsDelete_568227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an App Service Environment.
  ## 
  let valid = call_568235.validator(path, query, header, formData, body)
  let scheme = call_568235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568235.url(scheme.get, call_568235.host, call_568235.base,
                         call_568235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568235, url, valid)

proc call*(call_568236: Call_AppServiceEnvironmentsDelete_568227;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; forceDelete: bool = false): Recallable =
  ## appServiceEnvironmentsDelete
  ## Delete an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   forceDelete: bool
  ##              : Specify <code>true</code> to force the deletion even if the App Service Environment contains resources. The default is <code>false</code>.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568237 = newJObject()
  var query_568238 = newJObject()
  add(path_568237, "resourceGroupName", newJString(resourceGroupName))
  add(query_568238, "api-version", newJString(apiVersion))
  add(path_568237, "name", newJString(name))
  add(query_568238, "forceDelete", newJBool(forceDelete))
  add(path_568237, "subscriptionId", newJString(subscriptionId))
  result = call_568236.call(path_568237, query_568238, nil, nil, nil)

var appServiceEnvironmentsDelete* = Call_AppServiceEnvironmentsDelete_568227(
    name: "appServiceEnvironmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsDelete_568228, base: "",
    url: url_AppServiceEnvironmentsDelete_568229, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListCapacities_568252 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListCapacities_568254(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListCapacities_568253(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the used, available, and total worker capacity an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568255 = path.getOrDefault("resourceGroupName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "resourceGroupName", valid_568255
  var valid_568256 = path.getOrDefault("name")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "name", valid_568256
  var valid_568257 = path.getOrDefault("subscriptionId")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "subscriptionId", valid_568257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568258 = query.getOrDefault("api-version")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "api-version", valid_568258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568259: Call_AppServiceEnvironmentsListCapacities_568252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the used, available, and total worker capacity an App Service Environment.
  ## 
  let valid = call_568259.validator(path, query, header, formData, body)
  let scheme = call_568259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568259.url(scheme.get, call_568259.host, call_568259.base,
                         call_568259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568259, url, valid)

proc call*(call_568260: Call_AppServiceEnvironmentsListCapacities_568252;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListCapacities
  ## Get the used, available, and total worker capacity an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568261 = newJObject()
  var query_568262 = newJObject()
  add(path_568261, "resourceGroupName", newJString(resourceGroupName))
  add(query_568262, "api-version", newJString(apiVersion))
  add(path_568261, "name", newJString(name))
  add(path_568261, "subscriptionId", newJString(subscriptionId))
  result = call_568260.call(path_568261, query_568262, nil, nil, nil)

var appServiceEnvironmentsListCapacities* = Call_AppServiceEnvironmentsListCapacities_568252(
    name: "appServiceEnvironmentsListCapacities", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/capacities/compute",
    validator: validate_AppServiceEnvironmentsListCapacities_568253, base: "",
    url: url_AppServiceEnvironmentsListCapacities_568254, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListVips_568263 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListVips_568265(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsListVips_568264(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get IP addresses assigned to an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568266 = path.getOrDefault("resourceGroupName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "resourceGroupName", valid_568266
  var valid_568267 = path.getOrDefault("name")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "name", valid_568267
  var valid_568268 = path.getOrDefault("subscriptionId")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "subscriptionId", valid_568268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568269 = query.getOrDefault("api-version")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "api-version", valid_568269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568270: Call_AppServiceEnvironmentsListVips_568263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get IP addresses assigned to an App Service Environment.
  ## 
  let valid = call_568270.validator(path, query, header, formData, body)
  let scheme = call_568270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568270.url(scheme.get, call_568270.host, call_568270.base,
                         call_568270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568270, url, valid)

proc call*(call_568271: Call_AppServiceEnvironmentsListVips_568263;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListVips
  ## Get IP addresses assigned to an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568272 = newJObject()
  var query_568273 = newJObject()
  add(path_568272, "resourceGroupName", newJString(resourceGroupName))
  add(query_568273, "api-version", newJString(apiVersion))
  add(path_568272, "name", newJString(name))
  add(path_568272, "subscriptionId", newJString(subscriptionId))
  result = call_568271.call(path_568272, query_568273, nil, nil, nil)

var appServiceEnvironmentsListVips* = Call_AppServiceEnvironmentsListVips_568263(
    name: "appServiceEnvironmentsListVips", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/capacities/virtualip",
    validator: validate_AppServiceEnvironmentsListVips_568264, base: "",
    url: url_AppServiceEnvironmentsListVips_568265, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsChangeVnet_568274 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsChangeVnet_568276(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsChangeVnet_568275(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Move an App Service Environment to a different VNET.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568277 = path.getOrDefault("resourceGroupName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "resourceGroupName", valid_568277
  var valid_568278 = path.getOrDefault("name")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "name", valid_568278
  var valid_568279 = path.getOrDefault("subscriptionId")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "subscriptionId", valid_568279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568280 = query.getOrDefault("api-version")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "api-version", valid_568280
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

proc call*(call_568282: Call_AppServiceEnvironmentsChangeVnet_568274;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Move an App Service Environment to a different VNET.
  ## 
  let valid = call_568282.validator(path, query, header, formData, body)
  let scheme = call_568282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568282.url(scheme.get, call_568282.host, call_568282.base,
                         call_568282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568282, url, valid)

proc call*(call_568283: Call_AppServiceEnvironmentsChangeVnet_568274;
          resourceGroupName: string; vnetInfo: JsonNode; apiVersion: string;
          name: string; subscriptionId: string): Recallable =
  ## appServiceEnvironmentsChangeVnet
  ## Move an App Service Environment to a different VNET.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   vnetInfo: JObject (required)
  ##           : Details for the new virtual network.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568284 = newJObject()
  var query_568285 = newJObject()
  var body_568286 = newJObject()
  add(path_568284, "resourceGroupName", newJString(resourceGroupName))
  if vnetInfo != nil:
    body_568286 = vnetInfo
  add(query_568285, "api-version", newJString(apiVersion))
  add(path_568284, "name", newJString(name))
  add(path_568284, "subscriptionId", newJString(subscriptionId))
  result = call_568283.call(path_568284, query_568285, nil, nil, body_568286)

var appServiceEnvironmentsChangeVnet* = Call_AppServiceEnvironmentsChangeVnet_568274(
    name: "appServiceEnvironmentsChangeVnet", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/changeVirtualNetwork",
    validator: validate_AppServiceEnvironmentsChangeVnet_568275, base: "",
    url: url_AppServiceEnvironmentsChangeVnet_568276, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListDiagnostics_568287 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListDiagnostics_568289(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListDiagnostics_568288(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get diagnostic information for an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568290 = path.getOrDefault("resourceGroupName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "resourceGroupName", valid_568290
  var valid_568291 = path.getOrDefault("name")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "name", valid_568291
  var valid_568292 = path.getOrDefault("subscriptionId")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "subscriptionId", valid_568292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568293 = query.getOrDefault("api-version")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "api-version", valid_568293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568294: Call_AppServiceEnvironmentsListDiagnostics_568287;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get diagnostic information for an App Service Environment.
  ## 
  let valid = call_568294.validator(path, query, header, formData, body)
  let scheme = call_568294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568294.url(scheme.get, call_568294.host, call_568294.base,
                         call_568294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568294, url, valid)

proc call*(call_568295: Call_AppServiceEnvironmentsListDiagnostics_568287;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListDiagnostics
  ## Get diagnostic information for an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568296 = newJObject()
  var query_568297 = newJObject()
  add(path_568296, "resourceGroupName", newJString(resourceGroupName))
  add(query_568297, "api-version", newJString(apiVersion))
  add(path_568296, "name", newJString(name))
  add(path_568296, "subscriptionId", newJString(subscriptionId))
  result = call_568295.call(path_568296, query_568297, nil, nil, nil)

var appServiceEnvironmentsListDiagnostics* = Call_AppServiceEnvironmentsListDiagnostics_568287(
    name: "appServiceEnvironmentsListDiagnostics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/diagnostics",
    validator: validate_AppServiceEnvironmentsListDiagnostics_568288, base: "",
    url: url_AppServiceEnvironmentsListDiagnostics_568289, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetDiagnosticsItem_568298 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsGetDiagnosticsItem_568300(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsGetDiagnosticsItem_568299(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a diagnostics item for an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   diagnosticsName: JString (required)
  ##                  : Name of the diagnostics item.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568301 = path.getOrDefault("resourceGroupName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "resourceGroupName", valid_568301
  var valid_568302 = path.getOrDefault("name")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "name", valid_568302
  var valid_568303 = path.getOrDefault("subscriptionId")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "subscriptionId", valid_568303
  var valid_568304 = path.getOrDefault("diagnosticsName")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "diagnosticsName", valid_568304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568305 = query.getOrDefault("api-version")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "api-version", valid_568305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568306: Call_AppServiceEnvironmentsGetDiagnosticsItem_568298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a diagnostics item for an App Service Environment.
  ## 
  let valid = call_568306.validator(path, query, header, formData, body)
  let scheme = call_568306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568306.url(scheme.get, call_568306.host, call_568306.base,
                         call_568306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568306, url, valid)

proc call*(call_568307: Call_AppServiceEnvironmentsGetDiagnosticsItem_568298;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; diagnosticsName: string): Recallable =
  ## appServiceEnvironmentsGetDiagnosticsItem
  ## Get a diagnostics item for an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   diagnosticsName: string (required)
  ##                  : Name of the diagnostics item.
  var path_568308 = newJObject()
  var query_568309 = newJObject()
  add(path_568308, "resourceGroupName", newJString(resourceGroupName))
  add(query_568309, "api-version", newJString(apiVersion))
  add(path_568308, "name", newJString(name))
  add(path_568308, "subscriptionId", newJString(subscriptionId))
  add(path_568308, "diagnosticsName", newJString(diagnosticsName))
  result = call_568307.call(path_568308, query_568309, nil, nil, nil)

var appServiceEnvironmentsGetDiagnosticsItem* = Call_AppServiceEnvironmentsGetDiagnosticsItem_568298(
    name: "appServiceEnvironmentsGetDiagnosticsItem", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/diagnostics/{diagnosticsName}",
    validator: validate_AppServiceEnvironmentsGetDiagnosticsItem_568299, base: "",
    url: url_AppServiceEnvironmentsGetDiagnosticsItem_568300,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_568310 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_568312(
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

proc validate_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_568311(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the network endpoints of all inbound dependencies of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568313 = path.getOrDefault("resourceGroupName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "resourceGroupName", valid_568313
  var valid_568314 = path.getOrDefault("name")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "name", valid_568314
  var valid_568315 = path.getOrDefault("subscriptionId")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "subscriptionId", valid_568315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568316 = query.getOrDefault("api-version")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "api-version", valid_568316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568317: Call_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_568310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the network endpoints of all inbound dependencies of an App Service Environment.
  ## 
  let valid = call_568317.validator(path, query, header, formData, body)
  let scheme = call_568317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568317.url(scheme.get, call_568317.host, call_568317.base,
                         call_568317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568317, url, valid)

proc call*(call_568318: Call_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_568310;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsGetInboundNetworkDependenciesEndpoints
  ## Get the network endpoints of all inbound dependencies of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568319 = newJObject()
  var query_568320 = newJObject()
  add(path_568319, "resourceGroupName", newJString(resourceGroupName))
  add(query_568320, "api-version", newJString(apiVersion))
  add(path_568319, "name", newJString(name))
  add(path_568319, "subscriptionId", newJString(subscriptionId))
  result = call_568318.call(path_568319, query_568320, nil, nil, nil)

var appServiceEnvironmentsGetInboundNetworkDependenciesEndpoints* = Call_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_568310(
    name: "appServiceEnvironmentsGetInboundNetworkDependenciesEndpoints",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/inboundNetworkDependenciesEndpoints", validator: validate_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_568311,
    base: "",
    url: url_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_568312,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMetricDefinitions_568321 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListMetricDefinitions_568323(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListMetricDefinitions_568322(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get global metric definitions of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568324 = path.getOrDefault("resourceGroupName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "resourceGroupName", valid_568324
  var valid_568325 = path.getOrDefault("name")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "name", valid_568325
  var valid_568326 = path.getOrDefault("subscriptionId")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "subscriptionId", valid_568326
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568327 = query.getOrDefault("api-version")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "api-version", valid_568327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568328: Call_AppServiceEnvironmentsListMetricDefinitions_568321;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get global metric definitions of an App Service Environment.
  ## 
  let valid = call_568328.validator(path, query, header, formData, body)
  let scheme = call_568328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568328.url(scheme.get, call_568328.host, call_568328.base,
                         call_568328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568328, url, valid)

proc call*(call_568329: Call_AppServiceEnvironmentsListMetricDefinitions_568321;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListMetricDefinitions
  ## Get global metric definitions of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568330 = newJObject()
  var query_568331 = newJObject()
  add(path_568330, "resourceGroupName", newJString(resourceGroupName))
  add(query_568331, "api-version", newJString(apiVersion))
  add(path_568330, "name", newJString(name))
  add(path_568330, "subscriptionId", newJString(subscriptionId))
  result = call_568329.call(path_568330, query_568331, nil, nil, nil)

var appServiceEnvironmentsListMetricDefinitions* = Call_AppServiceEnvironmentsListMetricDefinitions_568321(
    name: "appServiceEnvironmentsListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/metricdefinitions",
    validator: validate_AppServiceEnvironmentsListMetricDefinitions_568322,
    base: "", url: url_AppServiceEnvironmentsListMetricDefinitions_568323,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMetrics_568332 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListMetrics_568334(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsListMetrics_568333(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get global metrics of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568336 = path.getOrDefault("resourceGroupName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "resourceGroupName", valid_568336
  var valid_568337 = path.getOrDefault("name")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "name", valid_568337
  var valid_568338 = path.getOrDefault("subscriptionId")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "subscriptionId", valid_568338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568339 = query.getOrDefault("api-version")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "api-version", valid_568339
  var valid_568340 = query.getOrDefault("details")
  valid_568340 = validateParameter(valid_568340, JBool, required = false, default = nil)
  if valid_568340 != nil:
    section.add "details", valid_568340
  var valid_568341 = query.getOrDefault("$filter")
  valid_568341 = validateParameter(valid_568341, JString, required = false,
                                 default = nil)
  if valid_568341 != nil:
    section.add "$filter", valid_568341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568342: Call_AppServiceEnvironmentsListMetrics_568332;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get global metrics of an App Service Environment.
  ## 
  let valid = call_568342.validator(path, query, header, formData, body)
  let scheme = call_568342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568342.url(scheme.get, call_568342.host, call_568342.base,
                         call_568342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568342, url, valid)

proc call*(call_568343: Call_AppServiceEnvironmentsListMetrics_568332;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; details: bool = false; Filter: string = ""): Recallable =
  ## appServiceEnvironmentsListMetrics
  ## Get global metrics of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   details: bool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   Filter: string
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_568344 = newJObject()
  var query_568345 = newJObject()
  add(path_568344, "resourceGroupName", newJString(resourceGroupName))
  add(query_568345, "api-version", newJString(apiVersion))
  add(path_568344, "name", newJString(name))
  add(query_568345, "details", newJBool(details))
  add(path_568344, "subscriptionId", newJString(subscriptionId))
  add(query_568345, "$filter", newJString(Filter))
  result = call_568343.call(path_568344, query_568345, nil, nil, nil)

var appServiceEnvironmentsListMetrics* = Call_AppServiceEnvironmentsListMetrics_568332(
    name: "appServiceEnvironmentsListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/metrics",
    validator: validate_AppServiceEnvironmentsListMetrics_568333, base: "",
    url: url_AppServiceEnvironmentsListMetrics_568334, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePools_568346 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListMultiRolePools_568348(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListMultiRolePools_568347(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all multi-role pools.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568349 = path.getOrDefault("resourceGroupName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "resourceGroupName", valid_568349
  var valid_568350 = path.getOrDefault("name")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "name", valid_568350
  var valid_568351 = path.getOrDefault("subscriptionId")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "subscriptionId", valid_568351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568352 = query.getOrDefault("api-version")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "api-version", valid_568352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568353: Call_AppServiceEnvironmentsListMultiRolePools_568346;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all multi-role pools.
  ## 
  let valid = call_568353.validator(path, query, header, formData, body)
  let scheme = call_568353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568353.url(scheme.get, call_568353.host, call_568353.base,
                         call_568353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568353, url, valid)

proc call*(call_568354: Call_AppServiceEnvironmentsListMultiRolePools_568346;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListMultiRolePools
  ## Get all multi-role pools.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568355 = newJObject()
  var query_568356 = newJObject()
  add(path_568355, "resourceGroupName", newJString(resourceGroupName))
  add(query_568356, "api-version", newJString(apiVersion))
  add(path_568355, "name", newJString(name))
  add(path_568355, "subscriptionId", newJString(subscriptionId))
  result = call_568354.call(path_568355, query_568356, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePools* = Call_AppServiceEnvironmentsListMultiRolePools_568346(
    name: "appServiceEnvironmentsListMultiRolePools", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools",
    validator: validate_AppServiceEnvironmentsListMultiRolePools_568347, base: "",
    url: url_AppServiceEnvironmentsListMultiRolePools_568348,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_568368 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_568370(
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

proc validate_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_568369(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create or update a multi-role pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568371 = path.getOrDefault("resourceGroupName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "resourceGroupName", valid_568371
  var valid_568372 = path.getOrDefault("name")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "name", valid_568372
  var valid_568373 = path.getOrDefault("subscriptionId")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "subscriptionId", valid_568373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568374 = query.getOrDefault("api-version")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "api-version", valid_568374
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

proc call*(call_568376: Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_568368;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a multi-role pool.
  ## 
  let valid = call_568376.validator(path, query, header, formData, body)
  let scheme = call_568376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568376.url(scheme.get, call_568376.host, call_568376.base,
                         call_568376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568376, url, valid)

proc call*(call_568377: Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_568368;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; multiRolePoolEnvelope: JsonNode): Recallable =
  ## appServiceEnvironmentsCreateOrUpdateMultiRolePool
  ## Create or update a multi-role pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   multiRolePoolEnvelope: JObject (required)
  ##                        : Properties of the multi-role pool.
  var path_568378 = newJObject()
  var query_568379 = newJObject()
  var body_568380 = newJObject()
  add(path_568378, "resourceGroupName", newJString(resourceGroupName))
  add(query_568379, "api-version", newJString(apiVersion))
  add(path_568378, "name", newJString(name))
  add(path_568378, "subscriptionId", newJString(subscriptionId))
  if multiRolePoolEnvelope != nil:
    body_568380 = multiRolePoolEnvelope
  result = call_568377.call(path_568378, query_568379, nil, nil, body_568380)

var appServiceEnvironmentsCreateOrUpdateMultiRolePool* = Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_568368(
    name: "appServiceEnvironmentsCreateOrUpdateMultiRolePool",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default",
    validator: validate_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_568369,
    base: "", url: url_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_568370,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetMultiRolePool_568357 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsGetMultiRolePool_568359(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsGetMultiRolePool_568358(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get properties of a multi-role pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568360 = path.getOrDefault("resourceGroupName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "resourceGroupName", valid_568360
  var valid_568361 = path.getOrDefault("name")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "name", valid_568361
  var valid_568362 = path.getOrDefault("subscriptionId")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "subscriptionId", valid_568362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568363 = query.getOrDefault("api-version")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "api-version", valid_568363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568364: Call_AppServiceEnvironmentsGetMultiRolePool_568357;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get properties of a multi-role pool.
  ## 
  let valid = call_568364.validator(path, query, header, formData, body)
  let scheme = call_568364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568364.url(scheme.get, call_568364.host, call_568364.base,
                         call_568364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568364, url, valid)

proc call*(call_568365: Call_AppServiceEnvironmentsGetMultiRolePool_568357;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsGetMultiRolePool
  ## Get properties of a multi-role pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568366 = newJObject()
  var query_568367 = newJObject()
  add(path_568366, "resourceGroupName", newJString(resourceGroupName))
  add(query_568367, "api-version", newJString(apiVersion))
  add(path_568366, "name", newJString(name))
  add(path_568366, "subscriptionId", newJString(subscriptionId))
  result = call_568365.call(path_568366, query_568367, nil, nil, nil)

var appServiceEnvironmentsGetMultiRolePool* = Call_AppServiceEnvironmentsGetMultiRolePool_568357(
    name: "appServiceEnvironmentsGetMultiRolePool", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default",
    validator: validate_AppServiceEnvironmentsGetMultiRolePool_568358, base: "",
    url: url_AppServiceEnvironmentsGetMultiRolePool_568359,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsUpdateMultiRolePool_568381 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsUpdateMultiRolePool_568383(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsUpdateMultiRolePool_568382(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a multi-role pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568384 = path.getOrDefault("resourceGroupName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "resourceGroupName", valid_568384
  var valid_568385 = path.getOrDefault("name")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "name", valid_568385
  var valid_568386 = path.getOrDefault("subscriptionId")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "subscriptionId", valid_568386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568387 = query.getOrDefault("api-version")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "api-version", valid_568387
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

proc call*(call_568389: Call_AppServiceEnvironmentsUpdateMultiRolePool_568381;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a multi-role pool.
  ## 
  let valid = call_568389.validator(path, query, header, formData, body)
  let scheme = call_568389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568389.url(scheme.get, call_568389.host, call_568389.base,
                         call_568389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568389, url, valid)

proc call*(call_568390: Call_AppServiceEnvironmentsUpdateMultiRolePool_568381;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; multiRolePoolEnvelope: JsonNode): Recallable =
  ## appServiceEnvironmentsUpdateMultiRolePool
  ## Create or update a multi-role pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   multiRolePoolEnvelope: JObject (required)
  ##                        : Properties of the multi-role pool.
  var path_568391 = newJObject()
  var query_568392 = newJObject()
  var body_568393 = newJObject()
  add(path_568391, "resourceGroupName", newJString(resourceGroupName))
  add(query_568392, "api-version", newJString(apiVersion))
  add(path_568391, "name", newJString(name))
  add(path_568391, "subscriptionId", newJString(subscriptionId))
  if multiRolePoolEnvelope != nil:
    body_568393 = multiRolePoolEnvelope
  result = call_568390.call(path_568391, query_568392, nil, nil, body_568393)

var appServiceEnvironmentsUpdateMultiRolePool* = Call_AppServiceEnvironmentsUpdateMultiRolePool_568381(
    name: "appServiceEnvironmentsUpdateMultiRolePool", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default",
    validator: validate_AppServiceEnvironmentsUpdateMultiRolePool_568382,
    base: "", url: url_AppServiceEnvironmentsUpdateMultiRolePool_568383,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_568394 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_568396(
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

proc validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_568395(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metric definitions for a specific instance of a multi-role pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: JString (required)
  ##           : Name of the instance in the multi-role pool.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568397 = path.getOrDefault("resourceGroupName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "resourceGroupName", valid_568397
  var valid_568398 = path.getOrDefault("name")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "name", valid_568398
  var valid_568399 = path.getOrDefault("subscriptionId")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "subscriptionId", valid_568399
  var valid_568400 = path.getOrDefault("instance")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "instance", valid_568400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568401 = query.getOrDefault("api-version")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "api-version", valid_568401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568402: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_568394;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a specific instance of a multi-role pool of an App Service Environment.
  ## 
  let valid = call_568402.validator(path, query, header, formData, body)
  let scheme = call_568402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568402.url(scheme.get, call_568402.host, call_568402.base,
                         call_568402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568402, url, valid)

proc call*(call_568403: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_568394;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; instance: string): Recallable =
  ## appServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions
  ## Get metric definitions for a specific instance of a multi-role pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: string (required)
  ##           : Name of the instance in the multi-role pool.
  var path_568404 = newJObject()
  var query_568405 = newJObject()
  add(path_568404, "resourceGroupName", newJString(resourceGroupName))
  add(query_568405, "api-version", newJString(apiVersion))
  add(path_568404, "name", newJString(name))
  add(path_568404, "subscriptionId", newJString(subscriptionId))
  add(path_568404, "instance", newJString(instance))
  result = call_568403.call(path_568404, query_568405, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions* = Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_568394(
    name: "appServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/instances/{instance}/metricdefinitions", validator: validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_568395,
    base: "",
    url: url_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_568396,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_568406 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_568408(
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

proc validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_568407(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metrics for a specific instance of a multi-role pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: JString (required)
  ##           : Name of the instance in the multi-role pool.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568409 = path.getOrDefault("resourceGroupName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "resourceGroupName", valid_568409
  var valid_568410 = path.getOrDefault("name")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "name", valid_568410
  var valid_568411 = path.getOrDefault("subscriptionId")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "subscriptionId", valid_568411
  var valid_568412 = path.getOrDefault("instance")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "instance", valid_568412
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568413 = query.getOrDefault("api-version")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "api-version", valid_568413
  var valid_568414 = query.getOrDefault("details")
  valid_568414 = validateParameter(valid_568414, JBool, required = false, default = nil)
  if valid_568414 != nil:
    section.add "details", valid_568414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568415: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_568406;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a specific instance of a multi-role pool of an App Service Environment.
  ## 
  let valid = call_568415.validator(path, query, header, formData, body)
  let scheme = call_568415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568415.url(scheme.get, call_568415.host, call_568415.base,
                         call_568415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568415, url, valid)

proc call*(call_568416: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_568406;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; instance: string; details: bool = false): Recallable =
  ## appServiceEnvironmentsListMultiRolePoolInstanceMetrics
  ## Get metrics for a specific instance of a multi-role pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   details: bool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: string (required)
  ##           : Name of the instance in the multi-role pool.
  var path_568417 = newJObject()
  var query_568418 = newJObject()
  add(path_568417, "resourceGroupName", newJString(resourceGroupName))
  add(query_568418, "api-version", newJString(apiVersion))
  add(path_568417, "name", newJString(name))
  add(query_568418, "details", newJBool(details))
  add(path_568417, "subscriptionId", newJString(subscriptionId))
  add(path_568417, "instance", newJString(instance))
  result = call_568416.call(path_568417, query_568418, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePoolInstanceMetrics* = Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_568406(
    name: "appServiceEnvironmentsListMultiRolePoolInstanceMetrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/instances/{instance}/metrics",
    validator: validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_568407,
    base: "", url: url_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_568408,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_568419 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListMultiRoleMetricDefinitions_568421(
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

proc validate_AppServiceEnvironmentsListMultiRoleMetricDefinitions_568420(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metric definitions for a multi-role pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568422 = path.getOrDefault("resourceGroupName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "resourceGroupName", valid_568422
  var valid_568423 = path.getOrDefault("name")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "name", valid_568423
  var valid_568424 = path.getOrDefault("subscriptionId")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "subscriptionId", valid_568424
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568425 = query.getOrDefault("api-version")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "api-version", valid_568425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568426: Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_568419;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a multi-role pool of an App Service Environment.
  ## 
  let valid = call_568426.validator(path, query, header, formData, body)
  let scheme = call_568426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568426.url(scheme.get, call_568426.host, call_568426.base,
                         call_568426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568426, url, valid)

proc call*(call_568427: Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_568419;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListMultiRoleMetricDefinitions
  ## Get metric definitions for a multi-role pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568428 = newJObject()
  var query_568429 = newJObject()
  add(path_568428, "resourceGroupName", newJString(resourceGroupName))
  add(query_568429, "api-version", newJString(apiVersion))
  add(path_568428, "name", newJString(name))
  add(path_568428, "subscriptionId", newJString(subscriptionId))
  result = call_568427.call(path_568428, query_568429, nil, nil, nil)

var appServiceEnvironmentsListMultiRoleMetricDefinitions* = Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_568419(
    name: "appServiceEnvironmentsListMultiRoleMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/metricdefinitions",
    validator: validate_AppServiceEnvironmentsListMultiRoleMetricDefinitions_568420,
    base: "", url: url_AppServiceEnvironmentsListMultiRoleMetricDefinitions_568421,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRoleMetrics_568430 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListMultiRoleMetrics_568432(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListMultiRoleMetrics_568431(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get metrics for a multi-role pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568433 = path.getOrDefault("resourceGroupName")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "resourceGroupName", valid_568433
  var valid_568434 = path.getOrDefault("name")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "name", valid_568434
  var valid_568435 = path.getOrDefault("subscriptionId")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "subscriptionId", valid_568435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   endTime: JString
  ##          : End time of the metrics query.
  ##   timeGrain: JString
  ##            : Time granularity of the metrics query.
  ##   startTime: JString
  ##            : Beginning time of the metrics query.
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568436 = query.getOrDefault("api-version")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "api-version", valid_568436
  var valid_568437 = query.getOrDefault("details")
  valid_568437 = validateParameter(valid_568437, JBool, required = false, default = nil)
  if valid_568437 != nil:
    section.add "details", valid_568437
  var valid_568438 = query.getOrDefault("endTime")
  valid_568438 = validateParameter(valid_568438, JString, required = false,
                                 default = nil)
  if valid_568438 != nil:
    section.add "endTime", valid_568438
  var valid_568439 = query.getOrDefault("timeGrain")
  valid_568439 = validateParameter(valid_568439, JString, required = false,
                                 default = nil)
  if valid_568439 != nil:
    section.add "timeGrain", valid_568439
  var valid_568440 = query.getOrDefault("startTime")
  valid_568440 = validateParameter(valid_568440, JString, required = false,
                                 default = nil)
  if valid_568440 != nil:
    section.add "startTime", valid_568440
  var valid_568441 = query.getOrDefault("$filter")
  valid_568441 = validateParameter(valid_568441, JString, required = false,
                                 default = nil)
  if valid_568441 != nil:
    section.add "$filter", valid_568441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568442: Call_AppServiceEnvironmentsListMultiRoleMetrics_568430;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a multi-role pool of an App Service Environment.
  ## 
  let valid = call_568442.validator(path, query, header, formData, body)
  let scheme = call_568442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568442.url(scheme.get, call_568442.host, call_568442.base,
                         call_568442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568442, url, valid)

proc call*(call_568443: Call_AppServiceEnvironmentsListMultiRoleMetrics_568430;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; details: bool = false; endTime: string = "";
          timeGrain: string = ""; startTime: string = ""; Filter: string = ""): Recallable =
  ## appServiceEnvironmentsListMultiRoleMetrics
  ## Get metrics for a multi-role pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   details: bool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   endTime: string
  ##          : End time of the metrics query.
  ##   timeGrain: string
  ##            : Time granularity of the metrics query.
  ##   startTime: string
  ##            : Beginning time of the metrics query.
  ##   Filter: string
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_568444 = newJObject()
  var query_568445 = newJObject()
  add(path_568444, "resourceGroupName", newJString(resourceGroupName))
  add(query_568445, "api-version", newJString(apiVersion))
  add(path_568444, "name", newJString(name))
  add(query_568445, "details", newJBool(details))
  add(path_568444, "subscriptionId", newJString(subscriptionId))
  add(query_568445, "endTime", newJString(endTime))
  add(query_568445, "timeGrain", newJString(timeGrain))
  add(query_568445, "startTime", newJString(startTime))
  add(query_568445, "$filter", newJString(Filter))
  result = call_568443.call(path_568444, query_568445, nil, nil, nil)

var appServiceEnvironmentsListMultiRoleMetrics* = Call_AppServiceEnvironmentsListMultiRoleMetrics_568430(
    name: "appServiceEnvironmentsListMultiRoleMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/metrics",
    validator: validate_AppServiceEnvironmentsListMultiRoleMetrics_568431,
    base: "", url: url_AppServiceEnvironmentsListMultiRoleMetrics_568432,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePoolSkus_568446 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListMultiRolePoolSkus_568448(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListMultiRolePoolSkus_568447(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get available SKUs for scaling a multi-role pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568449 = path.getOrDefault("resourceGroupName")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "resourceGroupName", valid_568449
  var valid_568450 = path.getOrDefault("name")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "name", valid_568450
  var valid_568451 = path.getOrDefault("subscriptionId")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "subscriptionId", valid_568451
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568452 = query.getOrDefault("api-version")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "api-version", valid_568452
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568453: Call_AppServiceEnvironmentsListMultiRolePoolSkus_568446;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get available SKUs for scaling a multi-role pool.
  ## 
  let valid = call_568453.validator(path, query, header, formData, body)
  let scheme = call_568453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568453.url(scheme.get, call_568453.host, call_568453.base,
                         call_568453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568453, url, valid)

proc call*(call_568454: Call_AppServiceEnvironmentsListMultiRolePoolSkus_568446;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListMultiRolePoolSkus
  ## Get available SKUs for scaling a multi-role pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568455 = newJObject()
  var query_568456 = newJObject()
  add(path_568455, "resourceGroupName", newJString(resourceGroupName))
  add(query_568456, "api-version", newJString(apiVersion))
  add(path_568455, "name", newJString(name))
  add(path_568455, "subscriptionId", newJString(subscriptionId))
  result = call_568454.call(path_568455, query_568456, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePoolSkus* = Call_AppServiceEnvironmentsListMultiRolePoolSkus_568446(
    name: "appServiceEnvironmentsListMultiRolePoolSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/skus",
    validator: validate_AppServiceEnvironmentsListMultiRolePoolSkus_568447,
    base: "", url: url_AppServiceEnvironmentsListMultiRolePoolSkus_568448,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRoleUsages_568457 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListMultiRoleUsages_568459(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListMultiRoleUsages_568458(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get usage metrics for a multi-role pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568460 = path.getOrDefault("resourceGroupName")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "resourceGroupName", valid_568460
  var valid_568461 = path.getOrDefault("name")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "name", valid_568461
  var valid_568462 = path.getOrDefault("subscriptionId")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "subscriptionId", valid_568462
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568463 = query.getOrDefault("api-version")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "api-version", valid_568463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568464: Call_AppServiceEnvironmentsListMultiRoleUsages_568457;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get usage metrics for a multi-role pool of an App Service Environment.
  ## 
  let valid = call_568464.validator(path, query, header, formData, body)
  let scheme = call_568464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568464.url(scheme.get, call_568464.host, call_568464.base,
                         call_568464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568464, url, valid)

proc call*(call_568465: Call_AppServiceEnvironmentsListMultiRoleUsages_568457;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListMultiRoleUsages
  ## Get usage metrics for a multi-role pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568466 = newJObject()
  var query_568467 = newJObject()
  add(path_568466, "resourceGroupName", newJString(resourceGroupName))
  add(query_568467, "api-version", newJString(apiVersion))
  add(path_568466, "name", newJString(name))
  add(path_568466, "subscriptionId", newJString(subscriptionId))
  result = call_568465.call(path_568466, query_568467, nil, nil, nil)

var appServiceEnvironmentsListMultiRoleUsages* = Call_AppServiceEnvironmentsListMultiRoleUsages_568457(
    name: "appServiceEnvironmentsListMultiRoleUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/usages",
    validator: validate_AppServiceEnvironmentsListMultiRoleUsages_568458,
    base: "", url: url_AppServiceEnvironmentsListMultiRoleUsages_568459,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListOperations_568468 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListOperations_568470(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListOperations_568469(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all currently running operations on the App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568471 = path.getOrDefault("resourceGroupName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "resourceGroupName", valid_568471
  var valid_568472 = path.getOrDefault("name")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "name", valid_568472
  var valid_568473 = path.getOrDefault("subscriptionId")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "subscriptionId", valid_568473
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568474 = query.getOrDefault("api-version")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "api-version", valid_568474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568475: Call_AppServiceEnvironmentsListOperations_568468;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all currently running operations on the App Service Environment.
  ## 
  let valid = call_568475.validator(path, query, header, formData, body)
  let scheme = call_568475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568475.url(scheme.get, call_568475.host, call_568475.base,
                         call_568475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568475, url, valid)

proc call*(call_568476: Call_AppServiceEnvironmentsListOperations_568468;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListOperations
  ## List all currently running operations on the App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568477 = newJObject()
  var query_568478 = newJObject()
  add(path_568477, "resourceGroupName", newJString(resourceGroupName))
  add(query_568478, "api-version", newJString(apiVersion))
  add(path_568477, "name", newJString(name))
  add(path_568477, "subscriptionId", newJString(subscriptionId))
  result = call_568476.call(path_568477, query_568478, nil, nil, nil)

var appServiceEnvironmentsListOperations* = Call_AppServiceEnvironmentsListOperations_568468(
    name: "appServiceEnvironmentsListOperations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/operations",
    validator: validate_AppServiceEnvironmentsListOperations_568469, base: "",
    url: url_AppServiceEnvironmentsListOperations_568470, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_568479 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_568481(
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

proc validate_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_568480(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the network endpoints of all outbound dependencies of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568482 = path.getOrDefault("resourceGroupName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "resourceGroupName", valid_568482
  var valid_568483 = path.getOrDefault("name")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "name", valid_568483
  var valid_568484 = path.getOrDefault("subscriptionId")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "subscriptionId", valid_568484
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568485 = query.getOrDefault("api-version")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "api-version", valid_568485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568486: Call_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_568479;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the network endpoints of all outbound dependencies of an App Service Environment.
  ## 
  let valid = call_568486.validator(path, query, header, formData, body)
  let scheme = call_568486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568486.url(scheme.get, call_568486.host, call_568486.base,
                         call_568486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568486, url, valid)

proc call*(call_568487: Call_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_568479;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints
  ## Get the network endpoints of all outbound dependencies of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568488 = newJObject()
  var query_568489 = newJObject()
  add(path_568488, "resourceGroupName", newJString(resourceGroupName))
  add(query_568489, "api-version", newJString(apiVersion))
  add(path_568488, "name", newJString(name))
  add(path_568488, "subscriptionId", newJString(subscriptionId))
  result = call_568487.call(path_568488, query_568489, nil, nil, nil)

var appServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints* = Call_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_568479(
    name: "appServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/outboundNetworkDependenciesEndpoints", validator: validate_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_568480,
    base: "",
    url: url_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_568481,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsReboot_568490 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsReboot_568492(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsReboot_568491(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reboot all machines in an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568493 = path.getOrDefault("resourceGroupName")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "resourceGroupName", valid_568493
  var valid_568494 = path.getOrDefault("name")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "name", valid_568494
  var valid_568495 = path.getOrDefault("subscriptionId")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "subscriptionId", valid_568495
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568496 = query.getOrDefault("api-version")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "api-version", valid_568496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568497: Call_AppServiceEnvironmentsReboot_568490; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reboot all machines in an App Service Environment.
  ## 
  let valid = call_568497.validator(path, query, header, formData, body)
  let scheme = call_568497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568497.url(scheme.get, call_568497.host, call_568497.base,
                         call_568497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568497, url, valid)

proc call*(call_568498: Call_AppServiceEnvironmentsReboot_568490;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsReboot
  ## Reboot all machines in an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568499 = newJObject()
  var query_568500 = newJObject()
  add(path_568499, "resourceGroupName", newJString(resourceGroupName))
  add(query_568500, "api-version", newJString(apiVersion))
  add(path_568499, "name", newJString(name))
  add(path_568499, "subscriptionId", newJString(subscriptionId))
  result = call_568498.call(path_568499, query_568500, nil, nil, nil)

var appServiceEnvironmentsReboot* = Call_AppServiceEnvironmentsReboot_568490(
    name: "appServiceEnvironmentsReboot", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/reboot",
    validator: validate_AppServiceEnvironmentsReboot_568491, base: "",
    url: url_AppServiceEnvironmentsReboot_568492, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsResume_568501 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsResume_568503(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsResume_568502(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resume an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568504 = path.getOrDefault("resourceGroupName")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "resourceGroupName", valid_568504
  var valid_568505 = path.getOrDefault("name")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "name", valid_568505
  var valid_568506 = path.getOrDefault("subscriptionId")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "subscriptionId", valid_568506
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568507 = query.getOrDefault("api-version")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "api-version", valid_568507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568508: Call_AppServiceEnvironmentsResume_568501; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume an App Service Environment.
  ## 
  let valid = call_568508.validator(path, query, header, formData, body)
  let scheme = call_568508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568508.url(scheme.get, call_568508.host, call_568508.base,
                         call_568508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568508, url, valid)

proc call*(call_568509: Call_AppServiceEnvironmentsResume_568501;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsResume
  ## Resume an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568510 = newJObject()
  var query_568511 = newJObject()
  add(path_568510, "resourceGroupName", newJString(resourceGroupName))
  add(query_568511, "api-version", newJString(apiVersion))
  add(path_568510, "name", newJString(name))
  add(path_568510, "subscriptionId", newJString(subscriptionId))
  result = call_568509.call(path_568510, query_568511, nil, nil, nil)

var appServiceEnvironmentsResume* = Call_AppServiceEnvironmentsResume_568501(
    name: "appServiceEnvironmentsResume", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/resume",
    validator: validate_AppServiceEnvironmentsResume_568502, base: "",
    url: url_AppServiceEnvironmentsResume_568503, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListAppServicePlans_568512 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListAppServicePlans_568514(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListAppServicePlans_568513(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all App Service plans in an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568515 = path.getOrDefault("resourceGroupName")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "resourceGroupName", valid_568515
  var valid_568516 = path.getOrDefault("name")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "name", valid_568516
  var valid_568517 = path.getOrDefault("subscriptionId")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "subscriptionId", valid_568517
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568518 = query.getOrDefault("api-version")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "api-version", valid_568518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568519: Call_AppServiceEnvironmentsListAppServicePlans_568512;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all App Service plans in an App Service Environment.
  ## 
  let valid = call_568519.validator(path, query, header, formData, body)
  let scheme = call_568519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568519.url(scheme.get, call_568519.host, call_568519.base,
                         call_568519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568519, url, valid)

proc call*(call_568520: Call_AppServiceEnvironmentsListAppServicePlans_568512;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListAppServicePlans
  ## Get all App Service plans in an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568521 = newJObject()
  var query_568522 = newJObject()
  add(path_568521, "resourceGroupName", newJString(resourceGroupName))
  add(query_568522, "api-version", newJString(apiVersion))
  add(path_568521, "name", newJString(name))
  add(path_568521, "subscriptionId", newJString(subscriptionId))
  result = call_568520.call(path_568521, query_568522, nil, nil, nil)

var appServiceEnvironmentsListAppServicePlans* = Call_AppServiceEnvironmentsListAppServicePlans_568512(
    name: "appServiceEnvironmentsListAppServicePlans", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/serverfarms",
    validator: validate_AppServiceEnvironmentsListAppServicePlans_568513,
    base: "", url: url_AppServiceEnvironmentsListAppServicePlans_568514,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebApps_568523 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListWebApps_568525(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsListWebApps_568524(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all apps in an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568526 = path.getOrDefault("resourceGroupName")
  valid_568526 = validateParameter(valid_568526, JString, required = true,
                                 default = nil)
  if valid_568526 != nil:
    section.add "resourceGroupName", valid_568526
  var valid_568527 = path.getOrDefault("name")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "name", valid_568527
  var valid_568528 = path.getOrDefault("subscriptionId")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "subscriptionId", valid_568528
  result.add "path", section
  ## parameters in `query` object:
  ##   propertiesToInclude: JString
  ##                      : Comma separated list of app properties to include.
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  var valid_568529 = query.getOrDefault("propertiesToInclude")
  valid_568529 = validateParameter(valid_568529, JString, required = false,
                                 default = nil)
  if valid_568529 != nil:
    section.add "propertiesToInclude", valid_568529
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568530 = query.getOrDefault("api-version")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "api-version", valid_568530
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568531: Call_AppServiceEnvironmentsListWebApps_568523;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all apps in an App Service Environment.
  ## 
  let valid = call_568531.validator(path, query, header, formData, body)
  let scheme = call_568531.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568531.url(scheme.get, call_568531.host, call_568531.base,
                         call_568531.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568531, url, valid)

proc call*(call_568532: Call_AppServiceEnvironmentsListWebApps_568523;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; propertiesToInclude: string = ""): Recallable =
  ## appServiceEnvironmentsListWebApps
  ## Get all apps in an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   propertiesToInclude: string
  ##                      : Comma separated list of app properties to include.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568533 = newJObject()
  var query_568534 = newJObject()
  add(path_568533, "resourceGroupName", newJString(resourceGroupName))
  add(query_568534, "propertiesToInclude", newJString(propertiesToInclude))
  add(query_568534, "api-version", newJString(apiVersion))
  add(path_568533, "name", newJString(name))
  add(path_568533, "subscriptionId", newJString(subscriptionId))
  result = call_568532.call(path_568533, query_568534, nil, nil, nil)

var appServiceEnvironmentsListWebApps* = Call_AppServiceEnvironmentsListWebApps_568523(
    name: "appServiceEnvironmentsListWebApps", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/sites",
    validator: validate_AppServiceEnvironmentsListWebApps_568524, base: "",
    url: url_AppServiceEnvironmentsListWebApps_568525, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsSuspend_568535 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsSuspend_568537(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsSuspend_568536(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Suspend an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568538 = path.getOrDefault("resourceGroupName")
  valid_568538 = validateParameter(valid_568538, JString, required = true,
                                 default = nil)
  if valid_568538 != nil:
    section.add "resourceGroupName", valid_568538
  var valid_568539 = path.getOrDefault("name")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "name", valid_568539
  var valid_568540 = path.getOrDefault("subscriptionId")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "subscriptionId", valid_568540
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568541 = query.getOrDefault("api-version")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "api-version", valid_568541
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568542: Call_AppServiceEnvironmentsSuspend_568535; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspend an App Service Environment.
  ## 
  let valid = call_568542.validator(path, query, header, formData, body)
  let scheme = call_568542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568542.url(scheme.get, call_568542.host, call_568542.base,
                         call_568542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568542, url, valid)

proc call*(call_568543: Call_AppServiceEnvironmentsSuspend_568535;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsSuspend
  ## Suspend an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568544 = newJObject()
  var query_568545 = newJObject()
  add(path_568544, "resourceGroupName", newJString(resourceGroupName))
  add(query_568545, "api-version", newJString(apiVersion))
  add(path_568544, "name", newJString(name))
  add(path_568544, "subscriptionId", newJString(subscriptionId))
  result = call_568543.call(path_568544, query_568545, nil, nil, nil)

var appServiceEnvironmentsSuspend* = Call_AppServiceEnvironmentsSuspend_568535(
    name: "appServiceEnvironmentsSuspend", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/suspend",
    validator: validate_AppServiceEnvironmentsSuspend_568536, base: "",
    url: url_AppServiceEnvironmentsSuspend_568537, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListUsages_568546 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListUsages_568548(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsListUsages_568547(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get global usage metrics of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568549 = path.getOrDefault("resourceGroupName")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "resourceGroupName", valid_568549
  var valid_568550 = path.getOrDefault("name")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "name", valid_568550
  var valid_568551 = path.getOrDefault("subscriptionId")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "subscriptionId", valid_568551
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568552 = query.getOrDefault("api-version")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "api-version", valid_568552
  var valid_568553 = query.getOrDefault("$filter")
  valid_568553 = validateParameter(valid_568553, JString, required = false,
                                 default = nil)
  if valid_568553 != nil:
    section.add "$filter", valid_568553
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568554: Call_AppServiceEnvironmentsListUsages_568546;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get global usage metrics of an App Service Environment.
  ## 
  let valid = call_568554.validator(path, query, header, formData, body)
  let scheme = call_568554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568554.url(scheme.get, call_568554.host, call_568554.base,
                         call_568554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568554, url, valid)

proc call*(call_568555: Call_AppServiceEnvironmentsListUsages_568546;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## appServiceEnvironmentsListUsages
  ## Get global usage metrics of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   Filter: string
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_568556 = newJObject()
  var query_568557 = newJObject()
  add(path_568556, "resourceGroupName", newJString(resourceGroupName))
  add(query_568557, "api-version", newJString(apiVersion))
  add(path_568556, "name", newJString(name))
  add(path_568556, "subscriptionId", newJString(subscriptionId))
  add(query_568557, "$filter", newJString(Filter))
  result = call_568555.call(path_568556, query_568557, nil, nil, nil)

var appServiceEnvironmentsListUsages* = Call_AppServiceEnvironmentsListUsages_568546(
    name: "appServiceEnvironmentsListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/usages",
    validator: validate_AppServiceEnvironmentsListUsages_568547, base: "",
    url: url_AppServiceEnvironmentsListUsages_568548, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPools_568558 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListWorkerPools_568560(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListWorkerPools_568559(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all worker pools of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568561 = path.getOrDefault("resourceGroupName")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "resourceGroupName", valid_568561
  var valid_568562 = path.getOrDefault("name")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "name", valid_568562
  var valid_568563 = path.getOrDefault("subscriptionId")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "subscriptionId", valid_568563
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568564 = query.getOrDefault("api-version")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "api-version", valid_568564
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568565: Call_AppServiceEnvironmentsListWorkerPools_568558;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all worker pools of an App Service Environment.
  ## 
  let valid = call_568565.validator(path, query, header, formData, body)
  let scheme = call_568565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568565.url(scheme.get, call_568565.host, call_568565.base,
                         call_568565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568565, url, valid)

proc call*(call_568566: Call_AppServiceEnvironmentsListWorkerPools_568558;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListWorkerPools
  ## Get all worker pools of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568567 = newJObject()
  var query_568568 = newJObject()
  add(path_568567, "resourceGroupName", newJString(resourceGroupName))
  add(query_568568, "api-version", newJString(apiVersion))
  add(path_568567, "name", newJString(name))
  add(path_568567, "subscriptionId", newJString(subscriptionId))
  result = call_568566.call(path_568567, query_568568, nil, nil, nil)

var appServiceEnvironmentsListWorkerPools* = Call_AppServiceEnvironmentsListWorkerPools_568558(
    name: "appServiceEnvironmentsListWorkerPools", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools",
    validator: validate_AppServiceEnvironmentsListWorkerPools_568559, base: "",
    url: url_AppServiceEnvironmentsListWorkerPools_568560, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_568581 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsCreateOrUpdateWorkerPool_568583(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsCreateOrUpdateWorkerPool_568582(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create or update a worker pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568584 = path.getOrDefault("resourceGroupName")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "resourceGroupName", valid_568584
  var valid_568585 = path.getOrDefault("name")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "name", valid_568585
  var valid_568586 = path.getOrDefault("workerPoolName")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "workerPoolName", valid_568586
  var valid_568587 = path.getOrDefault("subscriptionId")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "subscriptionId", valid_568587
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568588 = query.getOrDefault("api-version")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "api-version", valid_568588
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

proc call*(call_568590: Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_568581;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a worker pool.
  ## 
  let valid = call_568590.validator(path, query, header, formData, body)
  let scheme = call_568590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568590.url(scheme.get, call_568590.host, call_568590.base,
                         call_568590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568590, url, valid)

proc call*(call_568591: Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_568581;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string;
          workerPoolEnvelope: JsonNode): Recallable =
  ## appServiceEnvironmentsCreateOrUpdateWorkerPool
  ## Create or update a worker pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   workerPoolEnvelope: JObject (required)
  ##                     : Properties of the worker pool.
  var path_568592 = newJObject()
  var query_568593 = newJObject()
  var body_568594 = newJObject()
  add(path_568592, "resourceGroupName", newJString(resourceGroupName))
  add(query_568593, "api-version", newJString(apiVersion))
  add(path_568592, "name", newJString(name))
  add(path_568592, "workerPoolName", newJString(workerPoolName))
  add(path_568592, "subscriptionId", newJString(subscriptionId))
  if workerPoolEnvelope != nil:
    body_568594 = workerPoolEnvelope
  result = call_568591.call(path_568592, query_568593, nil, nil, body_568594)

var appServiceEnvironmentsCreateOrUpdateWorkerPool* = Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_568581(
    name: "appServiceEnvironmentsCreateOrUpdateWorkerPool",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}",
    validator: validate_AppServiceEnvironmentsCreateOrUpdateWorkerPool_568582,
    base: "", url: url_AppServiceEnvironmentsCreateOrUpdateWorkerPool_568583,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetWorkerPool_568569 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsGetWorkerPool_568571(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsGetWorkerPool_568570(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get properties of a worker pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568572 = path.getOrDefault("resourceGroupName")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "resourceGroupName", valid_568572
  var valid_568573 = path.getOrDefault("name")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "name", valid_568573
  var valid_568574 = path.getOrDefault("workerPoolName")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "workerPoolName", valid_568574
  var valid_568575 = path.getOrDefault("subscriptionId")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "subscriptionId", valid_568575
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568576 = query.getOrDefault("api-version")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "api-version", valid_568576
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568577: Call_AppServiceEnvironmentsGetWorkerPool_568569;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get properties of a worker pool.
  ## 
  let valid = call_568577.validator(path, query, header, formData, body)
  let scheme = call_568577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568577.url(scheme.get, call_568577.host, call_568577.base,
                         call_568577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568577, url, valid)

proc call*(call_568578: Call_AppServiceEnvironmentsGetWorkerPool_568569;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string): Recallable =
  ## appServiceEnvironmentsGetWorkerPool
  ## Get properties of a worker pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568579 = newJObject()
  var query_568580 = newJObject()
  add(path_568579, "resourceGroupName", newJString(resourceGroupName))
  add(query_568580, "api-version", newJString(apiVersion))
  add(path_568579, "name", newJString(name))
  add(path_568579, "workerPoolName", newJString(workerPoolName))
  add(path_568579, "subscriptionId", newJString(subscriptionId))
  result = call_568578.call(path_568579, query_568580, nil, nil, nil)

var appServiceEnvironmentsGetWorkerPool* = Call_AppServiceEnvironmentsGetWorkerPool_568569(
    name: "appServiceEnvironmentsGetWorkerPool", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}",
    validator: validate_AppServiceEnvironmentsGetWorkerPool_568570, base: "",
    url: url_AppServiceEnvironmentsGetWorkerPool_568571, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsUpdateWorkerPool_568595 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsUpdateWorkerPool_568597(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsUpdateWorkerPool_568596(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a worker pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568598 = path.getOrDefault("resourceGroupName")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "resourceGroupName", valid_568598
  var valid_568599 = path.getOrDefault("name")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "name", valid_568599
  var valid_568600 = path.getOrDefault("workerPoolName")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "workerPoolName", valid_568600
  var valid_568601 = path.getOrDefault("subscriptionId")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "subscriptionId", valid_568601
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568602 = query.getOrDefault("api-version")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "api-version", valid_568602
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

proc call*(call_568604: Call_AppServiceEnvironmentsUpdateWorkerPool_568595;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a worker pool.
  ## 
  let valid = call_568604.validator(path, query, header, formData, body)
  let scheme = call_568604.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568604.url(scheme.get, call_568604.host, call_568604.base,
                         call_568604.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568604, url, valid)

proc call*(call_568605: Call_AppServiceEnvironmentsUpdateWorkerPool_568595;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string;
          workerPoolEnvelope: JsonNode): Recallable =
  ## appServiceEnvironmentsUpdateWorkerPool
  ## Create or update a worker pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   workerPoolEnvelope: JObject (required)
  ##                     : Properties of the worker pool.
  var path_568606 = newJObject()
  var query_568607 = newJObject()
  var body_568608 = newJObject()
  add(path_568606, "resourceGroupName", newJString(resourceGroupName))
  add(query_568607, "api-version", newJString(apiVersion))
  add(path_568606, "name", newJString(name))
  add(path_568606, "workerPoolName", newJString(workerPoolName))
  add(path_568606, "subscriptionId", newJString(subscriptionId))
  if workerPoolEnvelope != nil:
    body_568608 = workerPoolEnvelope
  result = call_568605.call(path_568606, query_568607, nil, nil, body_568608)

var appServiceEnvironmentsUpdateWorkerPool* = Call_AppServiceEnvironmentsUpdateWorkerPool_568595(
    name: "appServiceEnvironmentsUpdateWorkerPool", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}",
    validator: validate_AppServiceEnvironmentsUpdateWorkerPool_568596, base: "",
    url: url_AppServiceEnvironmentsUpdateWorkerPool_568597,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_568609 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_568611(
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

proc validate_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_568610(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metric definitions for a specific instance of a worker pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: JString (required)
  ##           : Name of the instance in the worker pool.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568612 = path.getOrDefault("resourceGroupName")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "resourceGroupName", valid_568612
  var valid_568613 = path.getOrDefault("name")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "name", valid_568613
  var valid_568614 = path.getOrDefault("workerPoolName")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "workerPoolName", valid_568614
  var valid_568615 = path.getOrDefault("subscriptionId")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "subscriptionId", valid_568615
  var valid_568616 = path.getOrDefault("instance")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "instance", valid_568616
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568617 = query.getOrDefault("api-version")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "api-version", valid_568617
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568618: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_568609;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a specific instance of a worker pool of an App Service Environment.
  ## 
  let valid = call_568618.validator(path, query, header, formData, body)
  let scheme = call_568618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568618.url(scheme.get, call_568618.host, call_568618.base,
                         call_568618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568618, url, valid)

proc call*(call_568619: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_568609;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string; instance: string): Recallable =
  ## appServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions
  ## Get metric definitions for a specific instance of a worker pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: string (required)
  ##           : Name of the instance in the worker pool.
  var path_568620 = newJObject()
  var query_568621 = newJObject()
  add(path_568620, "resourceGroupName", newJString(resourceGroupName))
  add(query_568621, "api-version", newJString(apiVersion))
  add(path_568620, "name", newJString(name))
  add(path_568620, "workerPoolName", newJString(workerPoolName))
  add(path_568620, "subscriptionId", newJString(subscriptionId))
  add(path_568620, "instance", newJString(instance))
  result = call_568619.call(path_568620, query_568621, nil, nil, nil)

var appServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions* = Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_568609(
    name: "appServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/instances/{instance}/metricdefinitions", validator: validate_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_568610,
    base: "",
    url: url_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_568611,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_568622 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_568624(
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

proc validate_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_568623(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metrics for a specific instance of a worker pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: JString (required)
  ##           : Name of the instance in the worker pool.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568625 = path.getOrDefault("resourceGroupName")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "resourceGroupName", valid_568625
  var valid_568626 = path.getOrDefault("name")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "name", valid_568626
  var valid_568627 = path.getOrDefault("workerPoolName")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "workerPoolName", valid_568627
  var valid_568628 = path.getOrDefault("subscriptionId")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "subscriptionId", valid_568628
  var valid_568629 = path.getOrDefault("instance")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "instance", valid_568629
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568630 = query.getOrDefault("api-version")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "api-version", valid_568630
  var valid_568631 = query.getOrDefault("details")
  valid_568631 = validateParameter(valid_568631, JBool, required = false, default = nil)
  if valid_568631 != nil:
    section.add "details", valid_568631
  var valid_568632 = query.getOrDefault("$filter")
  valid_568632 = validateParameter(valid_568632, JString, required = false,
                                 default = nil)
  if valid_568632 != nil:
    section.add "$filter", valid_568632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568633: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_568622;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a specific instance of a worker pool of an App Service Environment.
  ## 
  let valid = call_568633.validator(path, query, header, formData, body)
  let scheme = call_568633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568633.url(scheme.get, call_568633.host, call_568633.base,
                         call_568633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568633, url, valid)

proc call*(call_568634: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_568622;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string; instance: string;
          details: bool = false; Filter: string = ""): Recallable =
  ## appServiceEnvironmentsListWorkerPoolInstanceMetrics
  ## Get metrics for a specific instance of a worker pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   details: bool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: string (required)
  ##           : Name of the instance in the worker pool.
  ##   Filter: string
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_568635 = newJObject()
  var query_568636 = newJObject()
  add(path_568635, "resourceGroupName", newJString(resourceGroupName))
  add(query_568636, "api-version", newJString(apiVersion))
  add(path_568635, "name", newJString(name))
  add(query_568636, "details", newJBool(details))
  add(path_568635, "workerPoolName", newJString(workerPoolName))
  add(path_568635, "subscriptionId", newJString(subscriptionId))
  add(path_568635, "instance", newJString(instance))
  add(query_568636, "$filter", newJString(Filter))
  result = call_568634.call(path_568635, query_568636, nil, nil, nil)

var appServiceEnvironmentsListWorkerPoolInstanceMetrics* = Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_568622(
    name: "appServiceEnvironmentsListWorkerPoolInstanceMetrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/instances/{instance}/metrics",
    validator: validate_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_568623,
    base: "", url: url_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_568624,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_568637 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListWebWorkerMetricDefinitions_568639(
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

proc validate_AppServiceEnvironmentsListWebWorkerMetricDefinitions_568638(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metric definitions for a worker pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568640 = path.getOrDefault("resourceGroupName")
  valid_568640 = validateParameter(valid_568640, JString, required = true,
                                 default = nil)
  if valid_568640 != nil:
    section.add "resourceGroupName", valid_568640
  var valid_568641 = path.getOrDefault("name")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "name", valid_568641
  var valid_568642 = path.getOrDefault("workerPoolName")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "workerPoolName", valid_568642
  var valid_568643 = path.getOrDefault("subscriptionId")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "subscriptionId", valid_568643
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568644 = query.getOrDefault("api-version")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "api-version", valid_568644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568645: Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_568637;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a worker pool of an App Service Environment.
  ## 
  let valid = call_568645.validator(path, query, header, formData, body)
  let scheme = call_568645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568645.url(scheme.get, call_568645.host, call_568645.base,
                         call_568645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568645, url, valid)

proc call*(call_568646: Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_568637;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListWebWorkerMetricDefinitions
  ## Get metric definitions for a worker pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568647 = newJObject()
  var query_568648 = newJObject()
  add(path_568647, "resourceGroupName", newJString(resourceGroupName))
  add(query_568648, "api-version", newJString(apiVersion))
  add(path_568647, "name", newJString(name))
  add(path_568647, "workerPoolName", newJString(workerPoolName))
  add(path_568647, "subscriptionId", newJString(subscriptionId))
  result = call_568646.call(path_568647, query_568648, nil, nil, nil)

var appServiceEnvironmentsListWebWorkerMetricDefinitions* = Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_568637(
    name: "appServiceEnvironmentsListWebWorkerMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/metricdefinitions",
    validator: validate_AppServiceEnvironmentsListWebWorkerMetricDefinitions_568638,
    base: "", url: url_AppServiceEnvironmentsListWebWorkerMetricDefinitions_568639,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebWorkerMetrics_568649 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListWebWorkerMetrics_568651(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListWebWorkerMetrics_568650(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get metrics for a worker pool of a AppServiceEnvironment (App Service Environment).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of worker pool
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568652 = path.getOrDefault("resourceGroupName")
  valid_568652 = validateParameter(valid_568652, JString, required = true,
                                 default = nil)
  if valid_568652 != nil:
    section.add "resourceGroupName", valid_568652
  var valid_568653 = path.getOrDefault("name")
  valid_568653 = validateParameter(valid_568653, JString, required = true,
                                 default = nil)
  if valid_568653 != nil:
    section.add "name", valid_568653
  var valid_568654 = path.getOrDefault("workerPoolName")
  valid_568654 = validateParameter(valid_568654, JString, required = true,
                                 default = nil)
  if valid_568654 != nil:
    section.add "workerPoolName", valid_568654
  var valid_568655 = path.getOrDefault("subscriptionId")
  valid_568655 = validateParameter(valid_568655, JString, required = true,
                                 default = nil)
  if valid_568655 != nil:
    section.add "subscriptionId", valid_568655
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568656 = query.getOrDefault("api-version")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "api-version", valid_568656
  var valid_568657 = query.getOrDefault("details")
  valid_568657 = validateParameter(valid_568657, JBool, required = false, default = nil)
  if valid_568657 != nil:
    section.add "details", valid_568657
  var valid_568658 = query.getOrDefault("$filter")
  valid_568658 = validateParameter(valid_568658, JString, required = false,
                                 default = nil)
  if valid_568658 != nil:
    section.add "$filter", valid_568658
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568659: Call_AppServiceEnvironmentsListWebWorkerMetrics_568649;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a worker pool of a AppServiceEnvironment (App Service Environment).
  ## 
  let valid = call_568659.validator(path, query, header, formData, body)
  let scheme = call_568659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568659.url(scheme.get, call_568659.host, call_568659.base,
                         call_568659.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568659, url, valid)

proc call*(call_568660: Call_AppServiceEnvironmentsListWebWorkerMetrics_568649;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string; details: bool = false;
          Filter: string = ""): Recallable =
  ## appServiceEnvironmentsListWebWorkerMetrics
  ## Get metrics for a worker pool of a AppServiceEnvironment (App Service Environment).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   details: bool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   workerPoolName: string (required)
  ##                 : Name of worker pool
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   Filter: string
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_568661 = newJObject()
  var query_568662 = newJObject()
  add(path_568661, "resourceGroupName", newJString(resourceGroupName))
  add(query_568662, "api-version", newJString(apiVersion))
  add(path_568661, "name", newJString(name))
  add(query_568662, "details", newJBool(details))
  add(path_568661, "workerPoolName", newJString(workerPoolName))
  add(path_568661, "subscriptionId", newJString(subscriptionId))
  add(query_568662, "$filter", newJString(Filter))
  result = call_568660.call(path_568661, query_568662, nil, nil, nil)

var appServiceEnvironmentsListWebWorkerMetrics* = Call_AppServiceEnvironmentsListWebWorkerMetrics_568649(
    name: "appServiceEnvironmentsListWebWorkerMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/metrics",
    validator: validate_AppServiceEnvironmentsListWebWorkerMetrics_568650,
    base: "", url: url_AppServiceEnvironmentsListWebWorkerMetrics_568651,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPoolSkus_568663 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListWorkerPoolSkus_568665(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListWorkerPoolSkus_568664(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get available SKUs for scaling a worker pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568666 = path.getOrDefault("resourceGroupName")
  valid_568666 = validateParameter(valid_568666, JString, required = true,
                                 default = nil)
  if valid_568666 != nil:
    section.add "resourceGroupName", valid_568666
  var valid_568667 = path.getOrDefault("name")
  valid_568667 = validateParameter(valid_568667, JString, required = true,
                                 default = nil)
  if valid_568667 != nil:
    section.add "name", valid_568667
  var valid_568668 = path.getOrDefault("workerPoolName")
  valid_568668 = validateParameter(valid_568668, JString, required = true,
                                 default = nil)
  if valid_568668 != nil:
    section.add "workerPoolName", valid_568668
  var valid_568669 = path.getOrDefault("subscriptionId")
  valid_568669 = validateParameter(valid_568669, JString, required = true,
                                 default = nil)
  if valid_568669 != nil:
    section.add "subscriptionId", valid_568669
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568670 = query.getOrDefault("api-version")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "api-version", valid_568670
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568671: Call_AppServiceEnvironmentsListWorkerPoolSkus_568663;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get available SKUs for scaling a worker pool.
  ## 
  let valid = call_568671.validator(path, query, header, formData, body)
  let scheme = call_568671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568671.url(scheme.get, call_568671.host, call_568671.base,
                         call_568671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568671, url, valid)

proc call*(call_568672: Call_AppServiceEnvironmentsListWorkerPoolSkus_568663;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListWorkerPoolSkus
  ## Get available SKUs for scaling a worker pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568673 = newJObject()
  var query_568674 = newJObject()
  add(path_568673, "resourceGroupName", newJString(resourceGroupName))
  add(query_568674, "api-version", newJString(apiVersion))
  add(path_568673, "name", newJString(name))
  add(path_568673, "workerPoolName", newJString(workerPoolName))
  add(path_568673, "subscriptionId", newJString(subscriptionId))
  result = call_568672.call(path_568673, query_568674, nil, nil, nil)

var appServiceEnvironmentsListWorkerPoolSkus* = Call_AppServiceEnvironmentsListWorkerPoolSkus_568663(
    name: "appServiceEnvironmentsListWorkerPoolSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/skus",
    validator: validate_AppServiceEnvironmentsListWorkerPoolSkus_568664, base: "",
    url: url_AppServiceEnvironmentsListWorkerPoolSkus_568665,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebWorkerUsages_568675 = ref object of OpenApiRestCall_567659
proc url_AppServiceEnvironmentsListWebWorkerUsages_568677(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListWebWorkerUsages_568676(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get usage metrics for a worker pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568678 = path.getOrDefault("resourceGroupName")
  valid_568678 = validateParameter(valid_568678, JString, required = true,
                                 default = nil)
  if valid_568678 != nil:
    section.add "resourceGroupName", valid_568678
  var valid_568679 = path.getOrDefault("name")
  valid_568679 = validateParameter(valid_568679, JString, required = true,
                                 default = nil)
  if valid_568679 != nil:
    section.add "name", valid_568679
  var valid_568680 = path.getOrDefault("workerPoolName")
  valid_568680 = validateParameter(valid_568680, JString, required = true,
                                 default = nil)
  if valid_568680 != nil:
    section.add "workerPoolName", valid_568680
  var valid_568681 = path.getOrDefault("subscriptionId")
  valid_568681 = validateParameter(valid_568681, JString, required = true,
                                 default = nil)
  if valid_568681 != nil:
    section.add "subscriptionId", valid_568681
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568682 = query.getOrDefault("api-version")
  valid_568682 = validateParameter(valid_568682, JString, required = true,
                                 default = nil)
  if valid_568682 != nil:
    section.add "api-version", valid_568682
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568683: Call_AppServiceEnvironmentsListWebWorkerUsages_568675;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get usage metrics for a worker pool of an App Service Environment.
  ## 
  let valid = call_568683.validator(path, query, header, formData, body)
  let scheme = call_568683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568683.url(scheme.get, call_568683.host, call_568683.base,
                         call_568683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568683, url, valid)

proc call*(call_568684: Call_AppServiceEnvironmentsListWebWorkerUsages_568675;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListWebWorkerUsages
  ## Get usage metrics for a worker pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568685 = newJObject()
  var query_568686 = newJObject()
  add(path_568685, "resourceGroupName", newJString(resourceGroupName))
  add(query_568686, "api-version", newJString(apiVersion))
  add(path_568685, "name", newJString(name))
  add(path_568685, "workerPoolName", newJString(workerPoolName))
  add(path_568685, "subscriptionId", newJString(subscriptionId))
  result = call_568684.call(path_568685, query_568686, nil, nil, nil)

var appServiceEnvironmentsListWebWorkerUsages* = Call_AppServiceEnvironmentsListWebWorkerUsages_568675(
    name: "appServiceEnvironmentsListWebWorkerUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/usages",
    validator: validate_AppServiceEnvironmentsListWebWorkerUsages_568676,
    base: "", url: url_AppServiceEnvironmentsListWebWorkerUsages_568677,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
