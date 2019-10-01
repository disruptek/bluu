
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  macServiceName = "web-AppServiceEnvironments"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppServiceEnvironmentsList_567879 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsList_567881(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsList_567880(path: JsonNode; query: JsonNode;
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
  var valid_568054 = path.getOrDefault("subscriptionId")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = nil)
  if valid_568054 != nil:
    section.add "subscriptionId", valid_568054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568055 = query.getOrDefault("api-version")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "api-version", valid_568055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568078: Call_AppServiceEnvironmentsList_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all App Service Environments for a subscription.
  ## 
  let valid = call_568078.validator(path, query, header, formData, body)
  let scheme = call_568078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568078.url(scheme.get, call_568078.host, call_568078.base,
                         call_568078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568078, url, valid)

proc call*(call_568149: Call_AppServiceEnvironmentsList_567879; apiVersion: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsList
  ## Get all App Service Environments for a subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568150 = newJObject()
  var query_568152 = newJObject()
  add(query_568152, "api-version", newJString(apiVersion))
  add(path_568150, "subscriptionId", newJString(subscriptionId))
  result = call_568149.call(path_568150, query_568152, nil, nil, nil)

var appServiceEnvironmentsList* = Call_AppServiceEnvironmentsList_567879(
    name: "appServiceEnvironmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/hostingEnvironments",
    validator: validate_AppServiceEnvironmentsList_567880, base: "",
    url: url_AppServiceEnvironmentsList_567881, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListByResourceGroup_568191 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListByResourceGroup_568193(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListByResourceGroup_568192(path: JsonNode;
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
  var valid_568194 = path.getOrDefault("resourceGroupName")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "resourceGroupName", valid_568194
  var valid_568195 = path.getOrDefault("subscriptionId")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "subscriptionId", valid_568195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568196 = query.getOrDefault("api-version")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "api-version", valid_568196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568197: Call_AppServiceEnvironmentsListByResourceGroup_568191;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all App Service Environments in a resource group.
  ## 
  let valid = call_568197.validator(path, query, header, formData, body)
  let scheme = call_568197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568197.url(scheme.get, call_568197.host, call_568197.base,
                         call_568197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568197, url, valid)

proc call*(call_568198: Call_AppServiceEnvironmentsListByResourceGroup_568191;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListByResourceGroup
  ## Get all App Service Environments in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568199 = newJObject()
  var query_568200 = newJObject()
  add(path_568199, "resourceGroupName", newJString(resourceGroupName))
  add(query_568200, "api-version", newJString(apiVersion))
  add(path_568199, "subscriptionId", newJString(subscriptionId))
  result = call_568198.call(path_568199, query_568200, nil, nil, nil)

var appServiceEnvironmentsListByResourceGroup* = Call_AppServiceEnvironmentsListByResourceGroup_568191(
    name: "appServiceEnvironmentsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments",
    validator: validate_AppServiceEnvironmentsListByResourceGroup_568192,
    base: "", url: url_AppServiceEnvironmentsListByResourceGroup_568193,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsCreateOrUpdate_568212 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsCreateOrUpdate_568214(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsCreateOrUpdate_568213(path: JsonNode;
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
  var valid_568215 = path.getOrDefault("resourceGroupName")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "resourceGroupName", valid_568215
  var valid_568216 = path.getOrDefault("name")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "name", valid_568216
  var valid_568217 = path.getOrDefault("subscriptionId")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "subscriptionId", valid_568217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
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
  ##   hostingEnvironmentEnvelope: JObject (required)
  ##                             : Configuration details of the App Service Environment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568220: Call_AppServiceEnvironmentsCreateOrUpdate_568212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an App Service Environment.
  ## 
  let valid = call_568220.validator(path, query, header, formData, body)
  let scheme = call_568220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568220.url(scheme.get, call_568220.host, call_568220.base,
                         call_568220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568220, url, valid)

proc call*(call_568221: Call_AppServiceEnvironmentsCreateOrUpdate_568212;
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
  var path_568222 = newJObject()
  var query_568223 = newJObject()
  var body_568224 = newJObject()
  add(path_568222, "resourceGroupName", newJString(resourceGroupName))
  add(query_568223, "api-version", newJString(apiVersion))
  add(path_568222, "name", newJString(name))
  if hostingEnvironmentEnvelope != nil:
    body_568224 = hostingEnvironmentEnvelope
  add(path_568222, "subscriptionId", newJString(subscriptionId))
  result = call_568221.call(path_568222, query_568223, nil, nil, body_568224)

var appServiceEnvironmentsCreateOrUpdate* = Call_AppServiceEnvironmentsCreateOrUpdate_568212(
    name: "appServiceEnvironmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsCreateOrUpdate_568213, base: "",
    url: url_AppServiceEnvironmentsCreateOrUpdate_568214, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGet_568201 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsGet_568203(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsGet_568202(path: JsonNode; query: JsonNode;
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
  var valid_568204 = path.getOrDefault("resourceGroupName")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "resourceGroupName", valid_568204
  var valid_568205 = path.getOrDefault("name")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "name", valid_568205
  var valid_568206 = path.getOrDefault("subscriptionId")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "subscriptionId", valid_568206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568207 = query.getOrDefault("api-version")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "api-version", valid_568207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568208: Call_AppServiceEnvironmentsGet_568201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the properties of an App Service Environment.
  ## 
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_AppServiceEnvironmentsGet_568201;
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
  var path_568210 = newJObject()
  var query_568211 = newJObject()
  add(path_568210, "resourceGroupName", newJString(resourceGroupName))
  add(query_568211, "api-version", newJString(apiVersion))
  add(path_568210, "name", newJString(name))
  add(path_568210, "subscriptionId", newJString(subscriptionId))
  result = call_568209.call(path_568210, query_568211, nil, nil, nil)

var appServiceEnvironmentsGet* = Call_AppServiceEnvironmentsGet_568201(
    name: "appServiceEnvironmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsGet_568202, base: "",
    url: url_AppServiceEnvironmentsGet_568203, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsUpdate_568237 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsUpdate_568239(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsUpdate_568238(path: JsonNode; query: JsonNode;
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
  var valid_568240 = path.getOrDefault("resourceGroupName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "resourceGroupName", valid_568240
  var valid_568241 = path.getOrDefault("name")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "name", valid_568241
  var valid_568242 = path.getOrDefault("subscriptionId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "subscriptionId", valid_568242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568243 = query.getOrDefault("api-version")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "api-version", valid_568243
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

proc call*(call_568245: Call_AppServiceEnvironmentsUpdate_568237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an App Service Environment.
  ## 
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_AppServiceEnvironmentsUpdate_568237;
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
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  var body_568249 = newJObject()
  add(path_568247, "resourceGroupName", newJString(resourceGroupName))
  add(query_568248, "api-version", newJString(apiVersion))
  add(path_568247, "name", newJString(name))
  if hostingEnvironmentEnvelope != nil:
    body_568249 = hostingEnvironmentEnvelope
  add(path_568247, "subscriptionId", newJString(subscriptionId))
  result = call_568246.call(path_568247, query_568248, nil, nil, body_568249)

var appServiceEnvironmentsUpdate* = Call_AppServiceEnvironmentsUpdate_568237(
    name: "appServiceEnvironmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsUpdate_568238, base: "",
    url: url_AppServiceEnvironmentsUpdate_568239, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsDelete_568225 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsDelete_568227(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsDelete_568226(path: JsonNode; query: JsonNode;
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
  var valid_568228 = path.getOrDefault("resourceGroupName")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "resourceGroupName", valid_568228
  var valid_568229 = path.getOrDefault("name")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "name", valid_568229
  var valid_568230 = path.getOrDefault("subscriptionId")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "subscriptionId", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   forceDelete: JBool
  ##              : Specify <code>true</code> to force the deletion even if the App Service Environment contains resources. The default is <code>false</code>.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568231 = query.getOrDefault("api-version")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "api-version", valid_568231
  var valid_568232 = query.getOrDefault("forceDelete")
  valid_568232 = validateParameter(valid_568232, JBool, required = false, default = nil)
  if valid_568232 != nil:
    section.add "forceDelete", valid_568232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568233: Call_AppServiceEnvironmentsDelete_568225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an App Service Environment.
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_AppServiceEnvironmentsDelete_568225;
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
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(path_568235, "resourceGroupName", newJString(resourceGroupName))
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "name", newJString(name))
  add(query_568236, "forceDelete", newJBool(forceDelete))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var appServiceEnvironmentsDelete* = Call_AppServiceEnvironmentsDelete_568225(
    name: "appServiceEnvironmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsDelete_568226, base: "",
    url: url_AppServiceEnvironmentsDelete_568227, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListCapacities_568250 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListCapacities_568252(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListCapacities_568251(path: JsonNode;
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
  var valid_568253 = path.getOrDefault("resourceGroupName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "resourceGroupName", valid_568253
  var valid_568254 = path.getOrDefault("name")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "name", valid_568254
  var valid_568255 = path.getOrDefault("subscriptionId")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "subscriptionId", valid_568255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568256 = query.getOrDefault("api-version")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "api-version", valid_568256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568257: Call_AppServiceEnvironmentsListCapacities_568250;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the used, available, and total worker capacity an App Service Environment.
  ## 
  let valid = call_568257.validator(path, query, header, formData, body)
  let scheme = call_568257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568257.url(scheme.get, call_568257.host, call_568257.base,
                         call_568257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568257, url, valid)

proc call*(call_568258: Call_AppServiceEnvironmentsListCapacities_568250;
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
  var path_568259 = newJObject()
  var query_568260 = newJObject()
  add(path_568259, "resourceGroupName", newJString(resourceGroupName))
  add(query_568260, "api-version", newJString(apiVersion))
  add(path_568259, "name", newJString(name))
  add(path_568259, "subscriptionId", newJString(subscriptionId))
  result = call_568258.call(path_568259, query_568260, nil, nil, nil)

var appServiceEnvironmentsListCapacities* = Call_AppServiceEnvironmentsListCapacities_568250(
    name: "appServiceEnvironmentsListCapacities", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/capacities/compute",
    validator: validate_AppServiceEnvironmentsListCapacities_568251, base: "",
    url: url_AppServiceEnvironmentsListCapacities_568252, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListVips_568261 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListVips_568263(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsListVips_568262(path: JsonNode;
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
  var valid_568264 = path.getOrDefault("resourceGroupName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "resourceGroupName", valid_568264
  var valid_568265 = path.getOrDefault("name")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "name", valid_568265
  var valid_568266 = path.getOrDefault("subscriptionId")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "subscriptionId", valid_568266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568267 = query.getOrDefault("api-version")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "api-version", valid_568267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568268: Call_AppServiceEnvironmentsListVips_568261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get IP addresses assigned to an App Service Environment.
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_AppServiceEnvironmentsListVips_568261;
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
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  add(path_568270, "resourceGroupName", newJString(resourceGroupName))
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "name", newJString(name))
  add(path_568270, "subscriptionId", newJString(subscriptionId))
  result = call_568269.call(path_568270, query_568271, nil, nil, nil)

var appServiceEnvironmentsListVips* = Call_AppServiceEnvironmentsListVips_568261(
    name: "appServiceEnvironmentsListVips", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/capacities/virtualip",
    validator: validate_AppServiceEnvironmentsListVips_568262, base: "",
    url: url_AppServiceEnvironmentsListVips_568263, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListDiagnostics_568272 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListDiagnostics_568274(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListDiagnostics_568273(path: JsonNode;
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
  var valid_568275 = path.getOrDefault("resourceGroupName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "resourceGroupName", valid_568275
  var valid_568276 = path.getOrDefault("name")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "name", valid_568276
  var valid_568277 = path.getOrDefault("subscriptionId")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "subscriptionId", valid_568277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568278 = query.getOrDefault("api-version")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "api-version", valid_568278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568279: Call_AppServiceEnvironmentsListDiagnostics_568272;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get diagnostic information for an App Service Environment.
  ## 
  let valid = call_568279.validator(path, query, header, formData, body)
  let scheme = call_568279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568279.url(scheme.get, call_568279.host, call_568279.base,
                         call_568279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568279, url, valid)

proc call*(call_568280: Call_AppServiceEnvironmentsListDiagnostics_568272;
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
  var path_568281 = newJObject()
  var query_568282 = newJObject()
  add(path_568281, "resourceGroupName", newJString(resourceGroupName))
  add(query_568282, "api-version", newJString(apiVersion))
  add(path_568281, "name", newJString(name))
  add(path_568281, "subscriptionId", newJString(subscriptionId))
  result = call_568280.call(path_568281, query_568282, nil, nil, nil)

var appServiceEnvironmentsListDiagnostics* = Call_AppServiceEnvironmentsListDiagnostics_568272(
    name: "appServiceEnvironmentsListDiagnostics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/diagnostics",
    validator: validate_AppServiceEnvironmentsListDiagnostics_568273, base: "",
    url: url_AppServiceEnvironmentsListDiagnostics_568274, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetDiagnosticsItem_568283 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsGetDiagnosticsItem_568285(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsGetDiagnosticsItem_568284(path: JsonNode;
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
  var valid_568286 = path.getOrDefault("resourceGroupName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "resourceGroupName", valid_568286
  var valid_568287 = path.getOrDefault("name")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "name", valid_568287
  var valid_568288 = path.getOrDefault("subscriptionId")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "subscriptionId", valid_568288
  var valid_568289 = path.getOrDefault("diagnosticsName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "diagnosticsName", valid_568289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568290 = query.getOrDefault("api-version")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "api-version", valid_568290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568291: Call_AppServiceEnvironmentsGetDiagnosticsItem_568283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a diagnostics item for an App Service Environment.
  ## 
  let valid = call_568291.validator(path, query, header, formData, body)
  let scheme = call_568291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568291.url(scheme.get, call_568291.host, call_568291.base,
                         call_568291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568291, url, valid)

proc call*(call_568292: Call_AppServiceEnvironmentsGetDiagnosticsItem_568283;
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
  var path_568293 = newJObject()
  var query_568294 = newJObject()
  add(path_568293, "resourceGroupName", newJString(resourceGroupName))
  add(query_568294, "api-version", newJString(apiVersion))
  add(path_568293, "name", newJString(name))
  add(path_568293, "subscriptionId", newJString(subscriptionId))
  add(path_568293, "diagnosticsName", newJString(diagnosticsName))
  result = call_568292.call(path_568293, query_568294, nil, nil, nil)

var appServiceEnvironmentsGetDiagnosticsItem* = Call_AppServiceEnvironmentsGetDiagnosticsItem_568283(
    name: "appServiceEnvironmentsGetDiagnosticsItem", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/diagnostics/{diagnosticsName}",
    validator: validate_AppServiceEnvironmentsGetDiagnosticsItem_568284, base: "",
    url: url_AppServiceEnvironmentsGetDiagnosticsItem_568285,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMetricDefinitions_568295 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListMetricDefinitions_568297(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListMetricDefinitions_568296(path: JsonNode;
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
  var valid_568298 = path.getOrDefault("resourceGroupName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "resourceGroupName", valid_568298
  var valid_568299 = path.getOrDefault("name")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "name", valid_568299
  var valid_568300 = path.getOrDefault("subscriptionId")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "subscriptionId", valid_568300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568301 = query.getOrDefault("api-version")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "api-version", valid_568301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568302: Call_AppServiceEnvironmentsListMetricDefinitions_568295;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get global metric definitions of an App Service Environment.
  ## 
  let valid = call_568302.validator(path, query, header, formData, body)
  let scheme = call_568302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568302.url(scheme.get, call_568302.host, call_568302.base,
                         call_568302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568302, url, valid)

proc call*(call_568303: Call_AppServiceEnvironmentsListMetricDefinitions_568295;
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
  var path_568304 = newJObject()
  var query_568305 = newJObject()
  add(path_568304, "resourceGroupName", newJString(resourceGroupName))
  add(query_568305, "api-version", newJString(apiVersion))
  add(path_568304, "name", newJString(name))
  add(path_568304, "subscriptionId", newJString(subscriptionId))
  result = call_568303.call(path_568304, query_568305, nil, nil, nil)

var appServiceEnvironmentsListMetricDefinitions* = Call_AppServiceEnvironmentsListMetricDefinitions_568295(
    name: "appServiceEnvironmentsListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/metricdefinitions",
    validator: validate_AppServiceEnvironmentsListMetricDefinitions_568296,
    base: "", url: url_AppServiceEnvironmentsListMetricDefinitions_568297,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMetrics_568306 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListMetrics_568308(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsListMetrics_568307(path: JsonNode;
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
  var valid_568310 = path.getOrDefault("resourceGroupName")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "resourceGroupName", valid_568310
  var valid_568311 = path.getOrDefault("name")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "name", valid_568311
  var valid_568312 = path.getOrDefault("subscriptionId")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "subscriptionId", valid_568312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568313 = query.getOrDefault("api-version")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "api-version", valid_568313
  var valid_568314 = query.getOrDefault("details")
  valid_568314 = validateParameter(valid_568314, JBool, required = false, default = nil)
  if valid_568314 != nil:
    section.add "details", valid_568314
  var valid_568315 = query.getOrDefault("$filter")
  valid_568315 = validateParameter(valid_568315, JString, required = false,
                                 default = nil)
  if valid_568315 != nil:
    section.add "$filter", valid_568315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568316: Call_AppServiceEnvironmentsListMetrics_568306;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get global metrics of an App Service Environment.
  ## 
  let valid = call_568316.validator(path, query, header, formData, body)
  let scheme = call_568316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568316.url(scheme.get, call_568316.host, call_568316.base,
                         call_568316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568316, url, valid)

proc call*(call_568317: Call_AppServiceEnvironmentsListMetrics_568306;
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
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_568318 = newJObject()
  var query_568319 = newJObject()
  add(path_568318, "resourceGroupName", newJString(resourceGroupName))
  add(query_568319, "api-version", newJString(apiVersion))
  add(path_568318, "name", newJString(name))
  add(query_568319, "details", newJBool(details))
  add(path_568318, "subscriptionId", newJString(subscriptionId))
  add(query_568319, "$filter", newJString(Filter))
  result = call_568317.call(path_568318, query_568319, nil, nil, nil)

var appServiceEnvironmentsListMetrics* = Call_AppServiceEnvironmentsListMetrics_568306(
    name: "appServiceEnvironmentsListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/metrics",
    validator: validate_AppServiceEnvironmentsListMetrics_568307, base: "",
    url: url_AppServiceEnvironmentsListMetrics_568308, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePools_568320 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListMultiRolePools_568322(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListMultiRolePools_568321(path: JsonNode;
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
  var valid_568323 = path.getOrDefault("resourceGroupName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "resourceGroupName", valid_568323
  var valid_568324 = path.getOrDefault("name")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "name", valid_568324
  var valid_568325 = path.getOrDefault("subscriptionId")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "subscriptionId", valid_568325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568326 = query.getOrDefault("api-version")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "api-version", valid_568326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568327: Call_AppServiceEnvironmentsListMultiRolePools_568320;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all multi-role pools.
  ## 
  let valid = call_568327.validator(path, query, header, formData, body)
  let scheme = call_568327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568327.url(scheme.get, call_568327.host, call_568327.base,
                         call_568327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568327, url, valid)

proc call*(call_568328: Call_AppServiceEnvironmentsListMultiRolePools_568320;
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
  var path_568329 = newJObject()
  var query_568330 = newJObject()
  add(path_568329, "resourceGroupName", newJString(resourceGroupName))
  add(query_568330, "api-version", newJString(apiVersion))
  add(path_568329, "name", newJString(name))
  add(path_568329, "subscriptionId", newJString(subscriptionId))
  result = call_568328.call(path_568329, query_568330, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePools* = Call_AppServiceEnvironmentsListMultiRolePools_568320(
    name: "appServiceEnvironmentsListMultiRolePools", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools",
    validator: validate_AppServiceEnvironmentsListMultiRolePools_568321, base: "",
    url: url_AppServiceEnvironmentsListMultiRolePools_568322,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_568342 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_568344(
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

proc validate_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_568343(
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
  var valid_568345 = path.getOrDefault("resourceGroupName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "resourceGroupName", valid_568345
  var valid_568346 = path.getOrDefault("name")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "name", valid_568346
  var valid_568347 = path.getOrDefault("subscriptionId")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "subscriptionId", valid_568347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568348 = query.getOrDefault("api-version")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "api-version", valid_568348
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

proc call*(call_568350: Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_568342;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a multi-role pool.
  ## 
  let valid = call_568350.validator(path, query, header, formData, body)
  let scheme = call_568350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568350.url(scheme.get, call_568350.host, call_568350.base,
                         call_568350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568350, url, valid)

proc call*(call_568351: Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_568342;
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
  var path_568352 = newJObject()
  var query_568353 = newJObject()
  var body_568354 = newJObject()
  add(path_568352, "resourceGroupName", newJString(resourceGroupName))
  add(query_568353, "api-version", newJString(apiVersion))
  add(path_568352, "name", newJString(name))
  add(path_568352, "subscriptionId", newJString(subscriptionId))
  if multiRolePoolEnvelope != nil:
    body_568354 = multiRolePoolEnvelope
  result = call_568351.call(path_568352, query_568353, nil, nil, body_568354)

var appServiceEnvironmentsCreateOrUpdateMultiRolePool* = Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_568342(
    name: "appServiceEnvironmentsCreateOrUpdateMultiRolePool",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default",
    validator: validate_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_568343,
    base: "", url: url_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_568344,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetMultiRolePool_568331 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsGetMultiRolePool_568333(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsGetMultiRolePool_568332(path: JsonNode;
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
  var valid_568334 = path.getOrDefault("resourceGroupName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "resourceGroupName", valid_568334
  var valid_568335 = path.getOrDefault("name")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "name", valid_568335
  var valid_568336 = path.getOrDefault("subscriptionId")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "subscriptionId", valid_568336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568337 = query.getOrDefault("api-version")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "api-version", valid_568337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568338: Call_AppServiceEnvironmentsGetMultiRolePool_568331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get properties of a multi-role pool.
  ## 
  let valid = call_568338.validator(path, query, header, formData, body)
  let scheme = call_568338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568338.url(scheme.get, call_568338.host, call_568338.base,
                         call_568338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568338, url, valid)

proc call*(call_568339: Call_AppServiceEnvironmentsGetMultiRolePool_568331;
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
  var path_568340 = newJObject()
  var query_568341 = newJObject()
  add(path_568340, "resourceGroupName", newJString(resourceGroupName))
  add(query_568341, "api-version", newJString(apiVersion))
  add(path_568340, "name", newJString(name))
  add(path_568340, "subscriptionId", newJString(subscriptionId))
  result = call_568339.call(path_568340, query_568341, nil, nil, nil)

var appServiceEnvironmentsGetMultiRolePool* = Call_AppServiceEnvironmentsGetMultiRolePool_568331(
    name: "appServiceEnvironmentsGetMultiRolePool", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default",
    validator: validate_AppServiceEnvironmentsGetMultiRolePool_568332, base: "",
    url: url_AppServiceEnvironmentsGetMultiRolePool_568333,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsUpdateMultiRolePool_568355 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsUpdateMultiRolePool_568357(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsUpdateMultiRolePool_568356(path: JsonNode;
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
  var valid_568358 = path.getOrDefault("resourceGroupName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "resourceGroupName", valid_568358
  var valid_568359 = path.getOrDefault("name")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "name", valid_568359
  var valid_568360 = path.getOrDefault("subscriptionId")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "subscriptionId", valid_568360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568361 = query.getOrDefault("api-version")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "api-version", valid_568361
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

proc call*(call_568363: Call_AppServiceEnvironmentsUpdateMultiRolePool_568355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a multi-role pool.
  ## 
  let valid = call_568363.validator(path, query, header, formData, body)
  let scheme = call_568363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568363.url(scheme.get, call_568363.host, call_568363.base,
                         call_568363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568363, url, valid)

proc call*(call_568364: Call_AppServiceEnvironmentsUpdateMultiRolePool_568355;
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
  var path_568365 = newJObject()
  var query_568366 = newJObject()
  var body_568367 = newJObject()
  add(path_568365, "resourceGroupName", newJString(resourceGroupName))
  add(query_568366, "api-version", newJString(apiVersion))
  add(path_568365, "name", newJString(name))
  add(path_568365, "subscriptionId", newJString(subscriptionId))
  if multiRolePoolEnvelope != nil:
    body_568367 = multiRolePoolEnvelope
  result = call_568364.call(path_568365, query_568366, nil, nil, body_568367)

var appServiceEnvironmentsUpdateMultiRolePool* = Call_AppServiceEnvironmentsUpdateMultiRolePool_568355(
    name: "appServiceEnvironmentsUpdateMultiRolePool", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default",
    validator: validate_AppServiceEnvironmentsUpdateMultiRolePool_568356,
    base: "", url: url_AppServiceEnvironmentsUpdateMultiRolePool_568357,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_568368 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_568370(
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

proc validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_568369(
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
  var valid_568374 = path.getOrDefault("instance")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "instance", valid_568374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568375 = query.getOrDefault("api-version")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "api-version", valid_568375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568376: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_568368;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a specific instance of a multi-role pool of an App Service Environment.
  ## 
  let valid = call_568376.validator(path, query, header, formData, body)
  let scheme = call_568376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568376.url(scheme.get, call_568376.host, call_568376.base,
                         call_568376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568376, url, valid)

proc call*(call_568377: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_568368;
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
  var path_568378 = newJObject()
  var query_568379 = newJObject()
  add(path_568378, "resourceGroupName", newJString(resourceGroupName))
  add(query_568379, "api-version", newJString(apiVersion))
  add(path_568378, "name", newJString(name))
  add(path_568378, "subscriptionId", newJString(subscriptionId))
  add(path_568378, "instance", newJString(instance))
  result = call_568377.call(path_568378, query_568379, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions* = Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_568368(
    name: "appServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/instances/{instance}/metricdefinitions", validator: validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_568369,
    base: "",
    url: url_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_568370,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_568380 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_568382(
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

proc validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_568381(
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
  var valid_568383 = path.getOrDefault("resourceGroupName")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "resourceGroupName", valid_568383
  var valid_568384 = path.getOrDefault("name")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "name", valid_568384
  var valid_568385 = path.getOrDefault("subscriptionId")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "subscriptionId", valid_568385
  var valid_568386 = path.getOrDefault("instance")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "instance", valid_568386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568387 = query.getOrDefault("api-version")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "api-version", valid_568387
  var valid_568388 = query.getOrDefault("details")
  valid_568388 = validateParameter(valid_568388, JBool, required = false, default = nil)
  if valid_568388 != nil:
    section.add "details", valid_568388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568389: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_568380;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a specific instance of a multi-role pool of an App Service Environment.
  ## 
  let valid = call_568389.validator(path, query, header, formData, body)
  let scheme = call_568389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568389.url(scheme.get, call_568389.host, call_568389.base,
                         call_568389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568389, url, valid)

proc call*(call_568390: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_568380;
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
  var path_568391 = newJObject()
  var query_568392 = newJObject()
  add(path_568391, "resourceGroupName", newJString(resourceGroupName))
  add(query_568392, "api-version", newJString(apiVersion))
  add(path_568391, "name", newJString(name))
  add(query_568392, "details", newJBool(details))
  add(path_568391, "subscriptionId", newJString(subscriptionId))
  add(path_568391, "instance", newJString(instance))
  result = call_568390.call(path_568391, query_568392, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePoolInstanceMetrics* = Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_568380(
    name: "appServiceEnvironmentsListMultiRolePoolInstanceMetrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/instances/{instance}/metrics",
    validator: validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_568381,
    base: "", url: url_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_568382,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_568393 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListMultiRoleMetricDefinitions_568395(
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

proc validate_AppServiceEnvironmentsListMultiRoleMetricDefinitions_568394(
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
  var valid_568396 = path.getOrDefault("resourceGroupName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "resourceGroupName", valid_568396
  var valid_568397 = path.getOrDefault("name")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "name", valid_568397
  var valid_568398 = path.getOrDefault("subscriptionId")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "subscriptionId", valid_568398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568399 = query.getOrDefault("api-version")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "api-version", valid_568399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568400: Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_568393;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a multi-role pool of an App Service Environment.
  ## 
  let valid = call_568400.validator(path, query, header, formData, body)
  let scheme = call_568400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568400.url(scheme.get, call_568400.host, call_568400.base,
                         call_568400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568400, url, valid)

proc call*(call_568401: Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_568393;
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
  var path_568402 = newJObject()
  var query_568403 = newJObject()
  add(path_568402, "resourceGroupName", newJString(resourceGroupName))
  add(query_568403, "api-version", newJString(apiVersion))
  add(path_568402, "name", newJString(name))
  add(path_568402, "subscriptionId", newJString(subscriptionId))
  result = call_568401.call(path_568402, query_568403, nil, nil, nil)

var appServiceEnvironmentsListMultiRoleMetricDefinitions* = Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_568393(
    name: "appServiceEnvironmentsListMultiRoleMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/metricdefinitions",
    validator: validate_AppServiceEnvironmentsListMultiRoleMetricDefinitions_568394,
    base: "", url: url_AppServiceEnvironmentsListMultiRoleMetricDefinitions_568395,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRoleMetrics_568404 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListMultiRoleMetrics_568406(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListMultiRoleMetrics_568405(path: JsonNode;
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
  var valid_568407 = path.getOrDefault("resourceGroupName")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "resourceGroupName", valid_568407
  var valid_568408 = path.getOrDefault("name")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "name", valid_568408
  var valid_568409 = path.getOrDefault("subscriptionId")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "subscriptionId", valid_568409
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
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568410 = query.getOrDefault("api-version")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "api-version", valid_568410
  var valid_568411 = query.getOrDefault("details")
  valid_568411 = validateParameter(valid_568411, JBool, required = false, default = nil)
  if valid_568411 != nil:
    section.add "details", valid_568411
  var valid_568412 = query.getOrDefault("endTime")
  valid_568412 = validateParameter(valid_568412, JString, required = false,
                                 default = nil)
  if valid_568412 != nil:
    section.add "endTime", valid_568412
  var valid_568413 = query.getOrDefault("timeGrain")
  valid_568413 = validateParameter(valid_568413, JString, required = false,
                                 default = nil)
  if valid_568413 != nil:
    section.add "timeGrain", valid_568413
  var valid_568414 = query.getOrDefault("startTime")
  valid_568414 = validateParameter(valid_568414, JString, required = false,
                                 default = nil)
  if valid_568414 != nil:
    section.add "startTime", valid_568414
  var valid_568415 = query.getOrDefault("$filter")
  valid_568415 = validateParameter(valid_568415, JString, required = false,
                                 default = nil)
  if valid_568415 != nil:
    section.add "$filter", valid_568415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568416: Call_AppServiceEnvironmentsListMultiRoleMetrics_568404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a multi-role pool of an App Service Environment.
  ## 
  let valid = call_568416.validator(path, query, header, formData, body)
  let scheme = call_568416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568416.url(scheme.get, call_568416.host, call_568416.base,
                         call_568416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568416, url, valid)

proc call*(call_568417: Call_AppServiceEnvironmentsListMultiRoleMetrics_568404;
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
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_568418 = newJObject()
  var query_568419 = newJObject()
  add(path_568418, "resourceGroupName", newJString(resourceGroupName))
  add(query_568419, "api-version", newJString(apiVersion))
  add(path_568418, "name", newJString(name))
  add(query_568419, "details", newJBool(details))
  add(path_568418, "subscriptionId", newJString(subscriptionId))
  add(query_568419, "endTime", newJString(endTime))
  add(query_568419, "timeGrain", newJString(timeGrain))
  add(query_568419, "startTime", newJString(startTime))
  add(query_568419, "$filter", newJString(Filter))
  result = call_568417.call(path_568418, query_568419, nil, nil, nil)

var appServiceEnvironmentsListMultiRoleMetrics* = Call_AppServiceEnvironmentsListMultiRoleMetrics_568404(
    name: "appServiceEnvironmentsListMultiRoleMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/metrics",
    validator: validate_AppServiceEnvironmentsListMultiRoleMetrics_568405,
    base: "", url: url_AppServiceEnvironmentsListMultiRoleMetrics_568406,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePoolSkus_568420 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListMultiRolePoolSkus_568422(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListMultiRolePoolSkus_568421(path: JsonNode;
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
  var valid_568423 = path.getOrDefault("resourceGroupName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "resourceGroupName", valid_568423
  var valid_568424 = path.getOrDefault("name")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "name", valid_568424
  var valid_568425 = path.getOrDefault("subscriptionId")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "subscriptionId", valid_568425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568426 = query.getOrDefault("api-version")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "api-version", valid_568426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568427: Call_AppServiceEnvironmentsListMultiRolePoolSkus_568420;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get available SKUs for scaling a multi-role pool.
  ## 
  let valid = call_568427.validator(path, query, header, formData, body)
  let scheme = call_568427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568427.url(scheme.get, call_568427.host, call_568427.base,
                         call_568427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568427, url, valid)

proc call*(call_568428: Call_AppServiceEnvironmentsListMultiRolePoolSkus_568420;
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
  var path_568429 = newJObject()
  var query_568430 = newJObject()
  add(path_568429, "resourceGroupName", newJString(resourceGroupName))
  add(query_568430, "api-version", newJString(apiVersion))
  add(path_568429, "name", newJString(name))
  add(path_568429, "subscriptionId", newJString(subscriptionId))
  result = call_568428.call(path_568429, query_568430, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePoolSkus* = Call_AppServiceEnvironmentsListMultiRolePoolSkus_568420(
    name: "appServiceEnvironmentsListMultiRolePoolSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/skus",
    validator: validate_AppServiceEnvironmentsListMultiRolePoolSkus_568421,
    base: "", url: url_AppServiceEnvironmentsListMultiRolePoolSkus_568422,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRoleUsages_568431 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListMultiRoleUsages_568433(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListMultiRoleUsages_568432(path: JsonNode;
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
  var valid_568434 = path.getOrDefault("resourceGroupName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "resourceGroupName", valid_568434
  var valid_568435 = path.getOrDefault("name")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "name", valid_568435
  var valid_568436 = path.getOrDefault("subscriptionId")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "subscriptionId", valid_568436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568437 = query.getOrDefault("api-version")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "api-version", valid_568437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568438: Call_AppServiceEnvironmentsListMultiRoleUsages_568431;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get usage metrics for a multi-role pool of an App Service Environment.
  ## 
  let valid = call_568438.validator(path, query, header, formData, body)
  let scheme = call_568438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568438.url(scheme.get, call_568438.host, call_568438.base,
                         call_568438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568438, url, valid)

proc call*(call_568439: Call_AppServiceEnvironmentsListMultiRoleUsages_568431;
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
  var path_568440 = newJObject()
  var query_568441 = newJObject()
  add(path_568440, "resourceGroupName", newJString(resourceGroupName))
  add(query_568441, "api-version", newJString(apiVersion))
  add(path_568440, "name", newJString(name))
  add(path_568440, "subscriptionId", newJString(subscriptionId))
  result = call_568439.call(path_568440, query_568441, nil, nil, nil)

var appServiceEnvironmentsListMultiRoleUsages* = Call_AppServiceEnvironmentsListMultiRoleUsages_568431(
    name: "appServiceEnvironmentsListMultiRoleUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/usages",
    validator: validate_AppServiceEnvironmentsListMultiRoleUsages_568432,
    base: "", url: url_AppServiceEnvironmentsListMultiRoleUsages_568433,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListOperations_568442 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListOperations_568444(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListOperations_568443(path: JsonNode;
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
  var valid_568445 = path.getOrDefault("resourceGroupName")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "resourceGroupName", valid_568445
  var valid_568446 = path.getOrDefault("name")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "name", valid_568446
  var valid_568447 = path.getOrDefault("subscriptionId")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "subscriptionId", valid_568447
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568448 = query.getOrDefault("api-version")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "api-version", valid_568448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568449: Call_AppServiceEnvironmentsListOperations_568442;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all currently running operations on the App Service Environment.
  ## 
  let valid = call_568449.validator(path, query, header, formData, body)
  let scheme = call_568449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568449.url(scheme.get, call_568449.host, call_568449.base,
                         call_568449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568449, url, valid)

proc call*(call_568450: Call_AppServiceEnvironmentsListOperations_568442;
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
  var path_568451 = newJObject()
  var query_568452 = newJObject()
  add(path_568451, "resourceGroupName", newJString(resourceGroupName))
  add(query_568452, "api-version", newJString(apiVersion))
  add(path_568451, "name", newJString(name))
  add(path_568451, "subscriptionId", newJString(subscriptionId))
  result = call_568450.call(path_568451, query_568452, nil, nil, nil)

var appServiceEnvironmentsListOperations* = Call_AppServiceEnvironmentsListOperations_568442(
    name: "appServiceEnvironmentsListOperations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/operations",
    validator: validate_AppServiceEnvironmentsListOperations_568443, base: "",
    url: url_AppServiceEnvironmentsListOperations_568444, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsReboot_568453 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsReboot_568455(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsReboot_568454(path: JsonNode; query: JsonNode;
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
  var valid_568456 = path.getOrDefault("resourceGroupName")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "resourceGroupName", valid_568456
  var valid_568457 = path.getOrDefault("name")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "name", valid_568457
  var valid_568458 = path.getOrDefault("subscriptionId")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "subscriptionId", valid_568458
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568459 = query.getOrDefault("api-version")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "api-version", valid_568459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568460: Call_AppServiceEnvironmentsReboot_568453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reboot all machines in an App Service Environment.
  ## 
  let valid = call_568460.validator(path, query, header, formData, body)
  let scheme = call_568460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568460.url(scheme.get, call_568460.host, call_568460.base,
                         call_568460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568460, url, valid)

proc call*(call_568461: Call_AppServiceEnvironmentsReboot_568453;
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
  var path_568462 = newJObject()
  var query_568463 = newJObject()
  add(path_568462, "resourceGroupName", newJString(resourceGroupName))
  add(query_568463, "api-version", newJString(apiVersion))
  add(path_568462, "name", newJString(name))
  add(path_568462, "subscriptionId", newJString(subscriptionId))
  result = call_568461.call(path_568462, query_568463, nil, nil, nil)

var appServiceEnvironmentsReboot* = Call_AppServiceEnvironmentsReboot_568453(
    name: "appServiceEnvironmentsReboot", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/reboot",
    validator: validate_AppServiceEnvironmentsReboot_568454, base: "",
    url: url_AppServiceEnvironmentsReboot_568455, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsResume_568464 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsResume_568466(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsResume_568465(path: JsonNode; query: JsonNode;
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
  var valid_568467 = path.getOrDefault("resourceGroupName")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "resourceGroupName", valid_568467
  var valid_568468 = path.getOrDefault("name")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "name", valid_568468
  var valid_568469 = path.getOrDefault("subscriptionId")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "subscriptionId", valid_568469
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568470 = query.getOrDefault("api-version")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "api-version", valid_568470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568471: Call_AppServiceEnvironmentsResume_568464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume an App Service Environment.
  ## 
  let valid = call_568471.validator(path, query, header, formData, body)
  let scheme = call_568471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568471.url(scheme.get, call_568471.host, call_568471.base,
                         call_568471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568471, url, valid)

proc call*(call_568472: Call_AppServiceEnvironmentsResume_568464;
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
  var path_568473 = newJObject()
  var query_568474 = newJObject()
  add(path_568473, "resourceGroupName", newJString(resourceGroupName))
  add(query_568474, "api-version", newJString(apiVersion))
  add(path_568473, "name", newJString(name))
  add(path_568473, "subscriptionId", newJString(subscriptionId))
  result = call_568472.call(path_568473, query_568474, nil, nil, nil)

var appServiceEnvironmentsResume* = Call_AppServiceEnvironmentsResume_568464(
    name: "appServiceEnvironmentsResume", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/resume",
    validator: validate_AppServiceEnvironmentsResume_568465, base: "",
    url: url_AppServiceEnvironmentsResume_568466, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListAppServicePlans_568475 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListAppServicePlans_568477(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListAppServicePlans_568476(path: JsonNode;
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
  var valid_568478 = path.getOrDefault("resourceGroupName")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "resourceGroupName", valid_568478
  var valid_568479 = path.getOrDefault("name")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "name", valid_568479
  var valid_568480 = path.getOrDefault("subscriptionId")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "subscriptionId", valid_568480
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568481 = query.getOrDefault("api-version")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "api-version", valid_568481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568482: Call_AppServiceEnvironmentsListAppServicePlans_568475;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all App Service plans in an App Service Environment.
  ## 
  let valid = call_568482.validator(path, query, header, formData, body)
  let scheme = call_568482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568482.url(scheme.get, call_568482.host, call_568482.base,
                         call_568482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568482, url, valid)

proc call*(call_568483: Call_AppServiceEnvironmentsListAppServicePlans_568475;
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
  var path_568484 = newJObject()
  var query_568485 = newJObject()
  add(path_568484, "resourceGroupName", newJString(resourceGroupName))
  add(query_568485, "api-version", newJString(apiVersion))
  add(path_568484, "name", newJString(name))
  add(path_568484, "subscriptionId", newJString(subscriptionId))
  result = call_568483.call(path_568484, query_568485, nil, nil, nil)

var appServiceEnvironmentsListAppServicePlans* = Call_AppServiceEnvironmentsListAppServicePlans_568475(
    name: "appServiceEnvironmentsListAppServicePlans", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/serverfarms",
    validator: validate_AppServiceEnvironmentsListAppServicePlans_568476,
    base: "", url: url_AppServiceEnvironmentsListAppServicePlans_568477,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebApps_568486 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListWebApps_568488(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsListWebApps_568487(path: JsonNode;
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
  var valid_568489 = path.getOrDefault("resourceGroupName")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "resourceGroupName", valid_568489
  var valid_568490 = path.getOrDefault("name")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "name", valid_568490
  var valid_568491 = path.getOrDefault("subscriptionId")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "subscriptionId", valid_568491
  result.add "path", section
  ## parameters in `query` object:
  ##   propertiesToInclude: JString
  ##                      : Comma separated list of app properties to include.
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  var valid_568492 = query.getOrDefault("propertiesToInclude")
  valid_568492 = validateParameter(valid_568492, JString, required = false,
                                 default = nil)
  if valid_568492 != nil:
    section.add "propertiesToInclude", valid_568492
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568493 = query.getOrDefault("api-version")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "api-version", valid_568493
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568494: Call_AppServiceEnvironmentsListWebApps_568486;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all apps in an App Service Environment.
  ## 
  let valid = call_568494.validator(path, query, header, formData, body)
  let scheme = call_568494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568494.url(scheme.get, call_568494.host, call_568494.base,
                         call_568494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568494, url, valid)

proc call*(call_568495: Call_AppServiceEnvironmentsListWebApps_568486;
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
  var path_568496 = newJObject()
  var query_568497 = newJObject()
  add(path_568496, "resourceGroupName", newJString(resourceGroupName))
  add(query_568497, "propertiesToInclude", newJString(propertiesToInclude))
  add(query_568497, "api-version", newJString(apiVersion))
  add(path_568496, "name", newJString(name))
  add(path_568496, "subscriptionId", newJString(subscriptionId))
  result = call_568495.call(path_568496, query_568497, nil, nil, nil)

var appServiceEnvironmentsListWebApps* = Call_AppServiceEnvironmentsListWebApps_568486(
    name: "appServiceEnvironmentsListWebApps", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/sites",
    validator: validate_AppServiceEnvironmentsListWebApps_568487, base: "",
    url: url_AppServiceEnvironmentsListWebApps_568488, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsSuspend_568498 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsSuspend_568500(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsSuspend_568499(path: JsonNode; query: JsonNode;
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
  var valid_568501 = path.getOrDefault("resourceGroupName")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "resourceGroupName", valid_568501
  var valid_568502 = path.getOrDefault("name")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "name", valid_568502
  var valid_568503 = path.getOrDefault("subscriptionId")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "subscriptionId", valid_568503
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568504 = query.getOrDefault("api-version")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "api-version", valid_568504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568505: Call_AppServiceEnvironmentsSuspend_568498; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspend an App Service Environment.
  ## 
  let valid = call_568505.validator(path, query, header, formData, body)
  let scheme = call_568505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568505.url(scheme.get, call_568505.host, call_568505.base,
                         call_568505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568505, url, valid)

proc call*(call_568506: Call_AppServiceEnvironmentsSuspend_568498;
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
  var path_568507 = newJObject()
  var query_568508 = newJObject()
  add(path_568507, "resourceGroupName", newJString(resourceGroupName))
  add(query_568508, "api-version", newJString(apiVersion))
  add(path_568507, "name", newJString(name))
  add(path_568507, "subscriptionId", newJString(subscriptionId))
  result = call_568506.call(path_568507, query_568508, nil, nil, nil)

var appServiceEnvironmentsSuspend* = Call_AppServiceEnvironmentsSuspend_568498(
    name: "appServiceEnvironmentsSuspend", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/suspend",
    validator: validate_AppServiceEnvironmentsSuspend_568499, base: "",
    url: url_AppServiceEnvironmentsSuspend_568500, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListUsages_568509 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListUsages_568511(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsListUsages_568510(path: JsonNode;
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
  var valid_568512 = path.getOrDefault("resourceGroupName")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "resourceGroupName", valid_568512
  var valid_568513 = path.getOrDefault("name")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "name", valid_568513
  var valid_568514 = path.getOrDefault("subscriptionId")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "subscriptionId", valid_568514
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568515 = query.getOrDefault("api-version")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "api-version", valid_568515
  var valid_568516 = query.getOrDefault("$filter")
  valid_568516 = validateParameter(valid_568516, JString, required = false,
                                 default = nil)
  if valid_568516 != nil:
    section.add "$filter", valid_568516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568517: Call_AppServiceEnvironmentsListUsages_568509;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get global usage metrics of an App Service Environment.
  ## 
  let valid = call_568517.validator(path, query, header, formData, body)
  let scheme = call_568517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568517.url(scheme.get, call_568517.host, call_568517.base,
                         call_568517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568517, url, valid)

proc call*(call_568518: Call_AppServiceEnvironmentsListUsages_568509;
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
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_568519 = newJObject()
  var query_568520 = newJObject()
  add(path_568519, "resourceGroupName", newJString(resourceGroupName))
  add(query_568520, "api-version", newJString(apiVersion))
  add(path_568519, "name", newJString(name))
  add(path_568519, "subscriptionId", newJString(subscriptionId))
  add(query_568520, "$filter", newJString(Filter))
  result = call_568518.call(path_568519, query_568520, nil, nil, nil)

var appServiceEnvironmentsListUsages* = Call_AppServiceEnvironmentsListUsages_568509(
    name: "appServiceEnvironmentsListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/usages",
    validator: validate_AppServiceEnvironmentsListUsages_568510, base: "",
    url: url_AppServiceEnvironmentsListUsages_568511, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPools_568521 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListWorkerPools_568523(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListWorkerPools_568522(path: JsonNode;
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
  var valid_568524 = path.getOrDefault("resourceGroupName")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "resourceGroupName", valid_568524
  var valid_568525 = path.getOrDefault("name")
  valid_568525 = validateParameter(valid_568525, JString, required = true,
                                 default = nil)
  if valid_568525 != nil:
    section.add "name", valid_568525
  var valid_568526 = path.getOrDefault("subscriptionId")
  valid_568526 = validateParameter(valid_568526, JString, required = true,
                                 default = nil)
  if valid_568526 != nil:
    section.add "subscriptionId", valid_568526
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568527 = query.getOrDefault("api-version")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "api-version", valid_568527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568528: Call_AppServiceEnvironmentsListWorkerPools_568521;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all worker pools of an App Service Environment.
  ## 
  let valid = call_568528.validator(path, query, header, formData, body)
  let scheme = call_568528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568528.url(scheme.get, call_568528.host, call_568528.base,
                         call_568528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568528, url, valid)

proc call*(call_568529: Call_AppServiceEnvironmentsListWorkerPools_568521;
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
  var path_568530 = newJObject()
  var query_568531 = newJObject()
  add(path_568530, "resourceGroupName", newJString(resourceGroupName))
  add(query_568531, "api-version", newJString(apiVersion))
  add(path_568530, "name", newJString(name))
  add(path_568530, "subscriptionId", newJString(subscriptionId))
  result = call_568529.call(path_568530, query_568531, nil, nil, nil)

var appServiceEnvironmentsListWorkerPools* = Call_AppServiceEnvironmentsListWorkerPools_568521(
    name: "appServiceEnvironmentsListWorkerPools", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools",
    validator: validate_AppServiceEnvironmentsListWorkerPools_568522, base: "",
    url: url_AppServiceEnvironmentsListWorkerPools_568523, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_568544 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsCreateOrUpdateWorkerPool_568546(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsCreateOrUpdateWorkerPool_568545(
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
  var valid_568547 = path.getOrDefault("resourceGroupName")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "resourceGroupName", valid_568547
  var valid_568548 = path.getOrDefault("name")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "name", valid_568548
  var valid_568549 = path.getOrDefault("workerPoolName")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "workerPoolName", valid_568549
  var valid_568550 = path.getOrDefault("subscriptionId")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "subscriptionId", valid_568550
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568551 = query.getOrDefault("api-version")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "api-version", valid_568551
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

proc call*(call_568553: Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_568544;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a worker pool.
  ## 
  let valid = call_568553.validator(path, query, header, formData, body)
  let scheme = call_568553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568553.url(scheme.get, call_568553.host, call_568553.base,
                         call_568553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568553, url, valid)

proc call*(call_568554: Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_568544;
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
  var path_568555 = newJObject()
  var query_568556 = newJObject()
  var body_568557 = newJObject()
  add(path_568555, "resourceGroupName", newJString(resourceGroupName))
  add(query_568556, "api-version", newJString(apiVersion))
  add(path_568555, "name", newJString(name))
  add(path_568555, "workerPoolName", newJString(workerPoolName))
  add(path_568555, "subscriptionId", newJString(subscriptionId))
  if workerPoolEnvelope != nil:
    body_568557 = workerPoolEnvelope
  result = call_568554.call(path_568555, query_568556, nil, nil, body_568557)

var appServiceEnvironmentsCreateOrUpdateWorkerPool* = Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_568544(
    name: "appServiceEnvironmentsCreateOrUpdateWorkerPool",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}",
    validator: validate_AppServiceEnvironmentsCreateOrUpdateWorkerPool_568545,
    base: "", url: url_AppServiceEnvironmentsCreateOrUpdateWorkerPool_568546,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetWorkerPool_568532 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsGetWorkerPool_568534(protocol: Scheme; host: string;
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

proc validate_AppServiceEnvironmentsGetWorkerPool_568533(path: JsonNode;
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
  var valid_568535 = path.getOrDefault("resourceGroupName")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "resourceGroupName", valid_568535
  var valid_568536 = path.getOrDefault("name")
  valid_568536 = validateParameter(valid_568536, JString, required = true,
                                 default = nil)
  if valid_568536 != nil:
    section.add "name", valid_568536
  var valid_568537 = path.getOrDefault("workerPoolName")
  valid_568537 = validateParameter(valid_568537, JString, required = true,
                                 default = nil)
  if valid_568537 != nil:
    section.add "workerPoolName", valid_568537
  var valid_568538 = path.getOrDefault("subscriptionId")
  valid_568538 = validateParameter(valid_568538, JString, required = true,
                                 default = nil)
  if valid_568538 != nil:
    section.add "subscriptionId", valid_568538
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568539 = query.getOrDefault("api-version")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "api-version", valid_568539
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568540: Call_AppServiceEnvironmentsGetWorkerPool_568532;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get properties of a worker pool.
  ## 
  let valid = call_568540.validator(path, query, header, formData, body)
  let scheme = call_568540.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568540.url(scheme.get, call_568540.host, call_568540.base,
                         call_568540.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568540, url, valid)

proc call*(call_568541: Call_AppServiceEnvironmentsGetWorkerPool_568532;
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
  var path_568542 = newJObject()
  var query_568543 = newJObject()
  add(path_568542, "resourceGroupName", newJString(resourceGroupName))
  add(query_568543, "api-version", newJString(apiVersion))
  add(path_568542, "name", newJString(name))
  add(path_568542, "workerPoolName", newJString(workerPoolName))
  add(path_568542, "subscriptionId", newJString(subscriptionId))
  result = call_568541.call(path_568542, query_568543, nil, nil, nil)

var appServiceEnvironmentsGetWorkerPool* = Call_AppServiceEnvironmentsGetWorkerPool_568532(
    name: "appServiceEnvironmentsGetWorkerPool", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}",
    validator: validate_AppServiceEnvironmentsGetWorkerPool_568533, base: "",
    url: url_AppServiceEnvironmentsGetWorkerPool_568534, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsUpdateWorkerPool_568558 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsUpdateWorkerPool_568560(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsUpdateWorkerPool_568559(path: JsonNode;
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
  var valid_568563 = path.getOrDefault("workerPoolName")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "workerPoolName", valid_568563
  var valid_568564 = path.getOrDefault("subscriptionId")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "subscriptionId", valid_568564
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568565 = query.getOrDefault("api-version")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "api-version", valid_568565
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

proc call*(call_568567: Call_AppServiceEnvironmentsUpdateWorkerPool_568558;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a worker pool.
  ## 
  let valid = call_568567.validator(path, query, header, formData, body)
  let scheme = call_568567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568567.url(scheme.get, call_568567.host, call_568567.base,
                         call_568567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568567, url, valid)

proc call*(call_568568: Call_AppServiceEnvironmentsUpdateWorkerPool_568558;
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
  var path_568569 = newJObject()
  var query_568570 = newJObject()
  var body_568571 = newJObject()
  add(path_568569, "resourceGroupName", newJString(resourceGroupName))
  add(query_568570, "api-version", newJString(apiVersion))
  add(path_568569, "name", newJString(name))
  add(path_568569, "workerPoolName", newJString(workerPoolName))
  add(path_568569, "subscriptionId", newJString(subscriptionId))
  if workerPoolEnvelope != nil:
    body_568571 = workerPoolEnvelope
  result = call_568568.call(path_568569, query_568570, nil, nil, body_568571)

var appServiceEnvironmentsUpdateWorkerPool* = Call_AppServiceEnvironmentsUpdateWorkerPool_568558(
    name: "appServiceEnvironmentsUpdateWorkerPool", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}",
    validator: validate_AppServiceEnvironmentsUpdateWorkerPool_568559, base: "",
    url: url_AppServiceEnvironmentsUpdateWorkerPool_568560,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_568572 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_568574(
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

proc validate_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_568573(
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
  var valid_568575 = path.getOrDefault("resourceGroupName")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "resourceGroupName", valid_568575
  var valid_568576 = path.getOrDefault("name")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "name", valid_568576
  var valid_568577 = path.getOrDefault("workerPoolName")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "workerPoolName", valid_568577
  var valid_568578 = path.getOrDefault("subscriptionId")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "subscriptionId", valid_568578
  var valid_568579 = path.getOrDefault("instance")
  valid_568579 = validateParameter(valid_568579, JString, required = true,
                                 default = nil)
  if valid_568579 != nil:
    section.add "instance", valid_568579
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568580 = query.getOrDefault("api-version")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "api-version", valid_568580
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568581: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_568572;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a specific instance of a worker pool of an App Service Environment.
  ## 
  let valid = call_568581.validator(path, query, header, formData, body)
  let scheme = call_568581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568581.url(scheme.get, call_568581.host, call_568581.base,
                         call_568581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568581, url, valid)

proc call*(call_568582: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_568572;
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
  var path_568583 = newJObject()
  var query_568584 = newJObject()
  add(path_568583, "resourceGroupName", newJString(resourceGroupName))
  add(query_568584, "api-version", newJString(apiVersion))
  add(path_568583, "name", newJString(name))
  add(path_568583, "workerPoolName", newJString(workerPoolName))
  add(path_568583, "subscriptionId", newJString(subscriptionId))
  add(path_568583, "instance", newJString(instance))
  result = call_568582.call(path_568583, query_568584, nil, nil, nil)

var appServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions* = Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_568572(
    name: "appServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/instances/{instance}/metricdefinitions", validator: validate_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_568573,
    base: "",
    url: url_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_568574,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_568585 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_568587(
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

proc validate_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_568586(
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
  var valid_568588 = path.getOrDefault("resourceGroupName")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "resourceGroupName", valid_568588
  var valid_568589 = path.getOrDefault("name")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "name", valid_568589
  var valid_568590 = path.getOrDefault("workerPoolName")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "workerPoolName", valid_568590
  var valid_568591 = path.getOrDefault("subscriptionId")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "subscriptionId", valid_568591
  var valid_568592 = path.getOrDefault("instance")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "instance", valid_568592
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568593 = query.getOrDefault("api-version")
  valid_568593 = validateParameter(valid_568593, JString, required = true,
                                 default = nil)
  if valid_568593 != nil:
    section.add "api-version", valid_568593
  var valid_568594 = query.getOrDefault("details")
  valid_568594 = validateParameter(valid_568594, JBool, required = false, default = nil)
  if valid_568594 != nil:
    section.add "details", valid_568594
  var valid_568595 = query.getOrDefault("$filter")
  valid_568595 = validateParameter(valid_568595, JString, required = false,
                                 default = nil)
  if valid_568595 != nil:
    section.add "$filter", valid_568595
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568596: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_568585;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a specific instance of a worker pool of an App Service Environment.
  ## 
  let valid = call_568596.validator(path, query, header, formData, body)
  let scheme = call_568596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568596.url(scheme.get, call_568596.host, call_568596.base,
                         call_568596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568596, url, valid)

proc call*(call_568597: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_568585;
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
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_568598 = newJObject()
  var query_568599 = newJObject()
  add(path_568598, "resourceGroupName", newJString(resourceGroupName))
  add(query_568599, "api-version", newJString(apiVersion))
  add(path_568598, "name", newJString(name))
  add(query_568599, "details", newJBool(details))
  add(path_568598, "workerPoolName", newJString(workerPoolName))
  add(path_568598, "subscriptionId", newJString(subscriptionId))
  add(path_568598, "instance", newJString(instance))
  add(query_568599, "$filter", newJString(Filter))
  result = call_568597.call(path_568598, query_568599, nil, nil, nil)

var appServiceEnvironmentsListWorkerPoolInstanceMetrics* = Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_568585(
    name: "appServiceEnvironmentsListWorkerPoolInstanceMetrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/instances/{instance}/metrics",
    validator: validate_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_568586,
    base: "", url: url_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_568587,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_568600 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListWebWorkerMetricDefinitions_568602(
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

proc validate_AppServiceEnvironmentsListWebWorkerMetricDefinitions_568601(
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
  var valid_568603 = path.getOrDefault("resourceGroupName")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "resourceGroupName", valid_568603
  var valid_568604 = path.getOrDefault("name")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "name", valid_568604
  var valid_568605 = path.getOrDefault("workerPoolName")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = nil)
  if valid_568605 != nil:
    section.add "workerPoolName", valid_568605
  var valid_568606 = path.getOrDefault("subscriptionId")
  valid_568606 = validateParameter(valid_568606, JString, required = true,
                                 default = nil)
  if valid_568606 != nil:
    section.add "subscriptionId", valid_568606
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568607 = query.getOrDefault("api-version")
  valid_568607 = validateParameter(valid_568607, JString, required = true,
                                 default = nil)
  if valid_568607 != nil:
    section.add "api-version", valid_568607
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568608: Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_568600;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a worker pool of an App Service Environment.
  ## 
  let valid = call_568608.validator(path, query, header, formData, body)
  let scheme = call_568608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568608.url(scheme.get, call_568608.host, call_568608.base,
                         call_568608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568608, url, valid)

proc call*(call_568609: Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_568600;
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
  var path_568610 = newJObject()
  var query_568611 = newJObject()
  add(path_568610, "resourceGroupName", newJString(resourceGroupName))
  add(query_568611, "api-version", newJString(apiVersion))
  add(path_568610, "name", newJString(name))
  add(path_568610, "workerPoolName", newJString(workerPoolName))
  add(path_568610, "subscriptionId", newJString(subscriptionId))
  result = call_568609.call(path_568610, query_568611, nil, nil, nil)

var appServiceEnvironmentsListWebWorkerMetricDefinitions* = Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_568600(
    name: "appServiceEnvironmentsListWebWorkerMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/metricdefinitions",
    validator: validate_AppServiceEnvironmentsListWebWorkerMetricDefinitions_568601,
    base: "", url: url_AppServiceEnvironmentsListWebWorkerMetricDefinitions_568602,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebWorkerMetrics_568612 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListWebWorkerMetrics_568614(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListWebWorkerMetrics_568613(path: JsonNode;
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
  var valid_568615 = path.getOrDefault("resourceGroupName")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "resourceGroupName", valid_568615
  var valid_568616 = path.getOrDefault("name")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "name", valid_568616
  var valid_568617 = path.getOrDefault("workerPoolName")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "workerPoolName", valid_568617
  var valid_568618 = path.getOrDefault("subscriptionId")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "subscriptionId", valid_568618
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568619 = query.getOrDefault("api-version")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "api-version", valid_568619
  var valid_568620 = query.getOrDefault("details")
  valid_568620 = validateParameter(valid_568620, JBool, required = false, default = nil)
  if valid_568620 != nil:
    section.add "details", valid_568620
  var valid_568621 = query.getOrDefault("$filter")
  valid_568621 = validateParameter(valid_568621, JString, required = false,
                                 default = nil)
  if valid_568621 != nil:
    section.add "$filter", valid_568621
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568622: Call_AppServiceEnvironmentsListWebWorkerMetrics_568612;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a worker pool of a AppServiceEnvironment (App Service Environment).
  ## 
  let valid = call_568622.validator(path, query, header, formData, body)
  let scheme = call_568622.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568622.url(scheme.get, call_568622.host, call_568622.base,
                         call_568622.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568622, url, valid)

proc call*(call_568623: Call_AppServiceEnvironmentsListWebWorkerMetrics_568612;
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
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_568624 = newJObject()
  var query_568625 = newJObject()
  add(path_568624, "resourceGroupName", newJString(resourceGroupName))
  add(query_568625, "api-version", newJString(apiVersion))
  add(path_568624, "name", newJString(name))
  add(query_568625, "details", newJBool(details))
  add(path_568624, "workerPoolName", newJString(workerPoolName))
  add(path_568624, "subscriptionId", newJString(subscriptionId))
  add(query_568625, "$filter", newJString(Filter))
  result = call_568623.call(path_568624, query_568625, nil, nil, nil)

var appServiceEnvironmentsListWebWorkerMetrics* = Call_AppServiceEnvironmentsListWebWorkerMetrics_568612(
    name: "appServiceEnvironmentsListWebWorkerMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/metrics",
    validator: validate_AppServiceEnvironmentsListWebWorkerMetrics_568613,
    base: "", url: url_AppServiceEnvironmentsListWebWorkerMetrics_568614,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPoolSkus_568626 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListWorkerPoolSkus_568628(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListWorkerPoolSkus_568627(path: JsonNode;
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
  var valid_568629 = path.getOrDefault("resourceGroupName")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "resourceGroupName", valid_568629
  var valid_568630 = path.getOrDefault("name")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "name", valid_568630
  var valid_568631 = path.getOrDefault("workerPoolName")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "workerPoolName", valid_568631
  var valid_568632 = path.getOrDefault("subscriptionId")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "subscriptionId", valid_568632
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568633 = query.getOrDefault("api-version")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "api-version", valid_568633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568634: Call_AppServiceEnvironmentsListWorkerPoolSkus_568626;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get available SKUs for scaling a worker pool.
  ## 
  let valid = call_568634.validator(path, query, header, formData, body)
  let scheme = call_568634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568634.url(scheme.get, call_568634.host, call_568634.base,
                         call_568634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568634, url, valid)

proc call*(call_568635: Call_AppServiceEnvironmentsListWorkerPoolSkus_568626;
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
  var path_568636 = newJObject()
  var query_568637 = newJObject()
  add(path_568636, "resourceGroupName", newJString(resourceGroupName))
  add(query_568637, "api-version", newJString(apiVersion))
  add(path_568636, "name", newJString(name))
  add(path_568636, "workerPoolName", newJString(workerPoolName))
  add(path_568636, "subscriptionId", newJString(subscriptionId))
  result = call_568635.call(path_568636, query_568637, nil, nil, nil)

var appServiceEnvironmentsListWorkerPoolSkus* = Call_AppServiceEnvironmentsListWorkerPoolSkus_568626(
    name: "appServiceEnvironmentsListWorkerPoolSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/skus",
    validator: validate_AppServiceEnvironmentsListWorkerPoolSkus_568627, base: "",
    url: url_AppServiceEnvironmentsListWorkerPoolSkus_568628,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebWorkerUsages_568638 = ref object of OpenApiRestCall_567657
proc url_AppServiceEnvironmentsListWebWorkerUsages_568640(protocol: Scheme;
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

proc validate_AppServiceEnvironmentsListWebWorkerUsages_568639(path: JsonNode;
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
  var valid_568641 = path.getOrDefault("resourceGroupName")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "resourceGroupName", valid_568641
  var valid_568642 = path.getOrDefault("name")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "name", valid_568642
  var valid_568643 = path.getOrDefault("workerPoolName")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "workerPoolName", valid_568643
  var valid_568644 = path.getOrDefault("subscriptionId")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "subscriptionId", valid_568644
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568645 = query.getOrDefault("api-version")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = nil)
  if valid_568645 != nil:
    section.add "api-version", valid_568645
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568646: Call_AppServiceEnvironmentsListWebWorkerUsages_568638;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get usage metrics for a worker pool of an App Service Environment.
  ## 
  let valid = call_568646.validator(path, query, header, formData, body)
  let scheme = call_568646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568646.url(scheme.get, call_568646.host, call_568646.base,
                         call_568646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568646, url, valid)

proc call*(call_568647: Call_AppServiceEnvironmentsListWebWorkerUsages_568638;
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
  var path_568648 = newJObject()
  var query_568649 = newJObject()
  add(path_568648, "resourceGroupName", newJString(resourceGroupName))
  add(query_568649, "api-version", newJString(apiVersion))
  add(path_568648, "name", newJString(name))
  add(path_568648, "workerPoolName", newJString(workerPoolName))
  add(path_568648, "subscriptionId", newJString(subscriptionId))
  result = call_568647.call(path_568648, query_568649, nil, nil, nil)

var appServiceEnvironmentsListWebWorkerUsages* = Call_AppServiceEnvironmentsListWebWorkerUsages_568638(
    name: "appServiceEnvironmentsListWebWorkerUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/usages",
    validator: validate_AppServiceEnvironmentsListWebWorkerUsages_568639,
    base: "", url: url_AppServiceEnvironmentsListWebWorkerUsages_568640,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
