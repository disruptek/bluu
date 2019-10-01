
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Migrate Hub
## version: 2018-09-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Migrate your workloads to Azure.
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

  OpenApiRestCall_567667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567667): Option[Scheme] {.used.} =
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
  macServiceName = "migrateprojects-migrate"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567889 = ref object of OpenApiRestCall_567667
proc url_OperationsList_567891(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567890(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_567996: Call_OperationsList_567889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  ## 
  let valid = call_567996.validator(path, query, header, formData, body)
  let scheme = call_567996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_567996.url(scheme.get, call_567996.host, call_567996.base,
                         call_567996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_567996, url, valid)

proc call*(call_568080: Call_OperationsList_567889): Recallable =
  ## operationsList
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  result = call_568080.call(nil, nil, nil, nil, nil)

var operationsList* = Call_OperationsList_567889(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Migrate/operations",
    validator: validate_OperationsList_567890, base: "", url: url_OperationsList_567891,
    schemes: {Scheme.Https})
type
  Call_MigrateProjectsPutMigrateProject_568221 = ref object of OpenApiRestCall_567667
proc url_MigrateProjectsPutMigrateProject_568223(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsPutMigrateProject_568222(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
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
  var valid_568226 = path.getOrDefault("migrateProjectName")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "migrateProjectName", valid_568226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568227 = query.getOrDefault("api-version")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568227 != nil:
    section.add "api-version", valid_568227
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568228 = header.getOrDefault("Accept-Language")
  valid_568228 = validateParameter(valid_568228, JString, required = false,
                                 default = nil)
  if valid_568228 != nil:
    section.add "Accept-Language", valid_568228
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Body with migrate project details.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568230: Call_MigrateProjectsPutMigrateProject_568221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_568230.validator(path, query, header, formData, body)
  let scheme = call_568230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568230.url(scheme.get, call_568230.host, call_568230.base,
                         call_568230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568230, url, valid)

proc call*(call_568231: Call_MigrateProjectsPutMigrateProject_568221;
          resourceGroupName: string; subscriptionId: string; body: JsonNode;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsPutMigrateProject
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   body: JObject (required)
  ##       : Body with migrate project details.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_568232 = newJObject()
  var query_568233 = newJObject()
  var body_568234 = newJObject()
  add(path_568232, "resourceGroupName", newJString(resourceGroupName))
  add(query_568233, "api-version", newJString(apiVersion))
  add(path_568232, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_568234 = body
  add(path_568232, "migrateProjectName", newJString(migrateProjectName))
  result = call_568231.call(path_568232, query_568233, nil, nil, body_568234)

var migrateProjectsPutMigrateProject* = Call_MigrateProjectsPutMigrateProject_568221(
    name: "migrateProjectsPutMigrateProject", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}",
    validator: validate_MigrateProjectsPutMigrateProject_568222, base: "",
    url: url_MigrateProjectsPutMigrateProject_568223, schemes: {Scheme.Https})
type
  Call_MigrateProjectsGetMigrateProject_568118 = ref object of OpenApiRestCall_567667
proc url_MigrateProjectsGetMigrateProject_568120(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsGetMigrateProject_568119(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568198 = path.getOrDefault("resourceGroupName")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "resourceGroupName", valid_568198
  var valid_568199 = path.getOrDefault("subscriptionId")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "subscriptionId", valid_568199
  var valid_568200 = path.getOrDefault("migrateProjectName")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "migrateProjectName", valid_568200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568214 != nil:
    section.add "api-version", valid_568214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568215: Call_MigrateProjectsGetMigrateProject_568118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_MigrateProjectsGetMigrateProject_568118;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsGetMigrateProject
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_568217 = newJObject()
  var query_568219 = newJObject()
  add(path_568217, "resourceGroupName", newJString(resourceGroupName))
  add(query_568219, "api-version", newJString(apiVersion))
  add(path_568217, "subscriptionId", newJString(subscriptionId))
  add(path_568217, "migrateProjectName", newJString(migrateProjectName))
  result = call_568216.call(path_568217, query_568219, nil, nil, nil)

var migrateProjectsGetMigrateProject* = Call_MigrateProjectsGetMigrateProject_568118(
    name: "migrateProjectsGetMigrateProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}",
    validator: validate_MigrateProjectsGetMigrateProject_568119, base: "",
    url: url_MigrateProjectsGetMigrateProject_568120, schemes: {Scheme.Https})
type
  Call_MigrateProjectsPatchMigrateProject_568247 = ref object of OpenApiRestCall_567667
proc url_MigrateProjectsPatchMigrateProject_568249(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsPatchMigrateProject_568248(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a migrate project with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568250 = path.getOrDefault("resourceGroupName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "resourceGroupName", valid_568250
  var valid_568251 = path.getOrDefault("subscriptionId")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "subscriptionId", valid_568251
  var valid_568252 = path.getOrDefault("migrateProjectName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "migrateProjectName", valid_568252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568253 = query.getOrDefault("api-version")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568253 != nil:
    section.add "api-version", valid_568253
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568254 = header.getOrDefault("Accept-Language")
  valid_568254 = validateParameter(valid_568254, JString, required = false,
                                 default = nil)
  if valid_568254 != nil:
    section.add "Accept-Language", valid_568254
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Body with migrate project details.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568256: Call_MigrateProjectsPatchMigrateProject_568247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a migrate project with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_MigrateProjectsPatchMigrateProject_568247;
          resourceGroupName: string; subscriptionId: string; body: JsonNode;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsPatchMigrateProject
  ## Update a migrate project with specified name. Supports partial updates, for example only tags can be provided.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   body: JObject (required)
  ##       : Body with migrate project details.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_568258 = newJObject()
  var query_568259 = newJObject()
  var body_568260 = newJObject()
  add(path_568258, "resourceGroupName", newJString(resourceGroupName))
  add(query_568259, "api-version", newJString(apiVersion))
  add(path_568258, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_568260 = body
  add(path_568258, "migrateProjectName", newJString(migrateProjectName))
  result = call_568257.call(path_568258, query_568259, nil, nil, body_568260)

var migrateProjectsPatchMigrateProject* = Call_MigrateProjectsPatchMigrateProject_568247(
    name: "migrateProjectsPatchMigrateProject", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}",
    validator: validate_MigrateProjectsPatchMigrateProject_568248, base: "",
    url: url_MigrateProjectsPatchMigrateProject_568249, schemes: {Scheme.Https})
type
  Call_MigrateProjectsDeleteMigrateProject_568235 = ref object of OpenApiRestCall_567667
proc url_MigrateProjectsDeleteMigrateProject_568237(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsDeleteMigrateProject_568236(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the migrate project. Deleting non-existent project is a no-operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568238 = path.getOrDefault("resourceGroupName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "resourceGroupName", valid_568238
  var valid_568239 = path.getOrDefault("subscriptionId")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "subscriptionId", valid_568239
  var valid_568240 = path.getOrDefault("migrateProjectName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "migrateProjectName", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568241 = query.getOrDefault("api-version")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568241 != nil:
    section.add "api-version", valid_568241
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568242 = header.getOrDefault("Accept-Language")
  valid_568242 = validateParameter(valid_568242, JString, required = false,
                                 default = nil)
  if valid_568242 != nil:
    section.add "Accept-Language", valid_568242
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568243: Call_MigrateProjectsDeleteMigrateProject_568235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the migrate project. Deleting non-existent project is a no-operation.
  ## 
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_MigrateProjectsDeleteMigrateProject_568235;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsDeleteMigrateProject
  ## Delete the migrate project. Deleting non-existent project is a no-operation.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_568245 = newJObject()
  var query_568246 = newJObject()
  add(path_568245, "resourceGroupName", newJString(resourceGroupName))
  add(query_568246, "api-version", newJString(apiVersion))
  add(path_568245, "subscriptionId", newJString(subscriptionId))
  add(path_568245, "migrateProjectName", newJString(migrateProjectName))
  result = call_568244.call(path_568245, query_568246, nil, nil, nil)

var migrateProjectsDeleteMigrateProject* = Call_MigrateProjectsDeleteMigrateProject_568235(
    name: "migrateProjectsDeleteMigrateProject", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}",
    validator: validate_MigrateProjectsDeleteMigrateProject_568236, base: "",
    url: url_MigrateProjectsDeleteMigrateProject_568237, schemes: {Scheme.Https})
type
  Call_DatabaseInstancesEnumerateDatabaseInstances_568261 = ref object of OpenApiRestCall_567667
proc url_DatabaseInstancesEnumerateDatabaseInstances_568263(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/databaseInstances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseInstancesEnumerateDatabaseInstances_568262(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568264 = path.getOrDefault("resourceGroupName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "resourceGroupName", valid_568264
  var valid_568265 = path.getOrDefault("subscriptionId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "subscriptionId", valid_568265
  var valid_568266 = path.getOrDefault("migrateProjectName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "migrateProjectName", valid_568266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  ##   continuationToken: JString
  ##                    : The continuation token.
  ##   pageSize: JInt
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568267 = query.getOrDefault("api-version")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568267 != nil:
    section.add "api-version", valid_568267
  var valid_568268 = query.getOrDefault("continuationToken")
  valid_568268 = validateParameter(valid_568268, JString, required = false,
                                 default = nil)
  if valid_568268 != nil:
    section.add "continuationToken", valid_568268
  var valid_568269 = query.getOrDefault("pageSize")
  valid_568269 = validateParameter(valid_568269, JInt, required = false, default = nil)
  if valid_568269 != nil:
    section.add "pageSize", valid_568269
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568270 = header.getOrDefault("Accept-Language")
  valid_568270 = validateParameter(valid_568270, JString, required = false,
                                 default = nil)
  if valid_568270 != nil:
    section.add "Accept-Language", valid_568270
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568271: Call_DatabaseInstancesEnumerateDatabaseInstances_568261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_568271.validator(path, query, header, formData, body)
  let scheme = call_568271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568271.url(scheme.get, call_568271.host, call_568271.base,
                         call_568271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568271, url, valid)

proc call*(call_568272: Call_DatabaseInstancesEnumerateDatabaseInstances_568261;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview";
          continuationToken: string = ""; pageSize: int = 0): Recallable =
  ## databaseInstancesEnumerateDatabaseInstances
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   pageSize: int
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_568273 = newJObject()
  var query_568274 = newJObject()
  add(path_568273, "resourceGroupName", newJString(resourceGroupName))
  add(query_568274, "api-version", newJString(apiVersion))
  add(path_568273, "subscriptionId", newJString(subscriptionId))
  add(query_568274, "continuationToken", newJString(continuationToken))
  add(query_568274, "pageSize", newJInt(pageSize))
  add(path_568273, "migrateProjectName", newJString(migrateProjectName))
  result = call_568272.call(path_568273, query_568274, nil, nil, nil)

var databaseInstancesEnumerateDatabaseInstances* = Call_DatabaseInstancesEnumerateDatabaseInstances_568261(
    name: "databaseInstancesEnumerateDatabaseInstances", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/databaseInstances",
    validator: validate_DatabaseInstancesEnumerateDatabaseInstances_568262,
    base: "", url: url_DatabaseInstancesEnumerateDatabaseInstances_568263,
    schemes: {Scheme.Https})
type
  Call_DatabaseInstancesGetDatabaseInstance_568275 = ref object of OpenApiRestCall_567667
proc url_DatabaseInstancesGetDatabaseInstance_568277(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "databaseInstanceName" in path,
        "`databaseInstanceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/databaseInstances/"),
               (kind: VariableSegment, value: "databaseInstanceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseInstancesGetDatabaseInstance_568276(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   databaseInstanceName: JString (required)
  ##                       : Unique name of a database instance in Azure migration hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568278 = path.getOrDefault("resourceGroupName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "resourceGroupName", valid_568278
  var valid_568279 = path.getOrDefault("subscriptionId")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "subscriptionId", valid_568279
  var valid_568280 = path.getOrDefault("migrateProjectName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "migrateProjectName", valid_568280
  var valid_568281 = path.getOrDefault("databaseInstanceName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "databaseInstanceName", valid_568281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568282 != nil:
    section.add "api-version", valid_568282
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568283 = header.getOrDefault("Accept-Language")
  valid_568283 = validateParameter(valid_568283, JString, required = false,
                                 default = nil)
  if valid_568283 != nil:
    section.add "Accept-Language", valid_568283
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568284: Call_DatabaseInstancesGetDatabaseInstance_568275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_568284.validator(path, query, header, formData, body)
  let scheme = call_568284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568284.url(scheme.get, call_568284.host, call_568284.base,
                         call_568284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568284, url, valid)

proc call*(call_568285: Call_DatabaseInstancesGetDatabaseInstance_568275;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; databaseInstanceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## databaseInstancesGetDatabaseInstance
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   databaseInstanceName: string (required)
  ##                       : Unique name of a database instance in Azure migration hub.
  var path_568286 = newJObject()
  var query_568287 = newJObject()
  add(path_568286, "resourceGroupName", newJString(resourceGroupName))
  add(query_568287, "api-version", newJString(apiVersion))
  add(path_568286, "subscriptionId", newJString(subscriptionId))
  add(path_568286, "migrateProjectName", newJString(migrateProjectName))
  add(path_568286, "databaseInstanceName", newJString(databaseInstanceName))
  result = call_568285.call(path_568286, query_568287, nil, nil, nil)

var databaseInstancesGetDatabaseInstance* = Call_DatabaseInstancesGetDatabaseInstance_568275(
    name: "databaseInstancesGetDatabaseInstance", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/databaseInstances/{databaseInstanceName}",
    validator: validate_DatabaseInstancesGetDatabaseInstance_568276, base: "",
    url: url_DatabaseInstancesGetDatabaseInstance_568277, schemes: {Scheme.Https})
type
  Call_DatabasesEnumerateDatabases_568288 = ref object of OpenApiRestCall_567667
proc url_DatabasesEnumerateDatabases_568290(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/databases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesEnumerateDatabases_568289(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568291 = path.getOrDefault("resourceGroupName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "resourceGroupName", valid_568291
  var valid_568292 = path.getOrDefault("subscriptionId")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "subscriptionId", valid_568292
  var valid_568293 = path.getOrDefault("migrateProjectName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "migrateProjectName", valid_568293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  ##   continuationToken: JString
  ##                    : The continuation token.
  ##   pageSize: JInt
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568294 = query.getOrDefault("api-version")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568294 != nil:
    section.add "api-version", valid_568294
  var valid_568295 = query.getOrDefault("continuationToken")
  valid_568295 = validateParameter(valid_568295, JString, required = false,
                                 default = nil)
  if valid_568295 != nil:
    section.add "continuationToken", valid_568295
  var valid_568296 = query.getOrDefault("pageSize")
  valid_568296 = validateParameter(valid_568296, JInt, required = false, default = nil)
  if valid_568296 != nil:
    section.add "pageSize", valid_568296
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568297 = header.getOrDefault("Accept-Language")
  valid_568297 = validateParameter(valid_568297, JString, required = false,
                                 default = nil)
  if valid_568297 != nil:
    section.add "Accept-Language", valid_568297
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568298: Call_DatabasesEnumerateDatabases_568288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568298.validator(path, query, header, formData, body)
  let scheme = call_568298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568298.url(scheme.get, call_568298.host, call_568298.base,
                         call_568298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568298, url, valid)

proc call*(call_568299: Call_DatabasesEnumerateDatabases_568288;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview";
          continuationToken: string = ""; pageSize: int = 0): Recallable =
  ## databasesEnumerateDatabases
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   pageSize: int
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_568300 = newJObject()
  var query_568301 = newJObject()
  add(path_568300, "resourceGroupName", newJString(resourceGroupName))
  add(query_568301, "api-version", newJString(apiVersion))
  add(path_568300, "subscriptionId", newJString(subscriptionId))
  add(query_568301, "continuationToken", newJString(continuationToken))
  add(query_568301, "pageSize", newJInt(pageSize))
  add(path_568300, "migrateProjectName", newJString(migrateProjectName))
  result = call_568299.call(path_568300, query_568301, nil, nil, nil)

var databasesEnumerateDatabases* = Call_DatabasesEnumerateDatabases_568288(
    name: "databasesEnumerateDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/databases",
    validator: validate_DatabasesEnumerateDatabases_568289, base: "",
    url: url_DatabasesEnumerateDatabases_568290, schemes: {Scheme.Https})
type
  Call_DatabasesGetDatabase_568302 = ref object of OpenApiRestCall_567667
proc url_DatabasesGetDatabase_568304(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesGetDatabase_568303(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   databaseName: JString (required)
  ##               : Unique name of a database in Azure migration hub.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568305 = path.getOrDefault("resourceGroupName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "resourceGroupName", valid_568305
  var valid_568306 = path.getOrDefault("subscriptionId")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "subscriptionId", valid_568306
  var valid_568307 = path.getOrDefault("databaseName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "databaseName", valid_568307
  var valid_568308 = path.getOrDefault("migrateProjectName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "migrateProjectName", valid_568308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568309 = query.getOrDefault("api-version")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568309 != nil:
    section.add "api-version", valid_568309
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568310 = header.getOrDefault("Accept-Language")
  valid_568310 = validateParameter(valid_568310, JString, required = false,
                                 default = nil)
  if valid_568310 != nil:
    section.add "Accept-Language", valid_568310
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568311: Call_DatabasesGetDatabase_568302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568311.validator(path, query, header, formData, body)
  let scheme = call_568311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568311.url(scheme.get, call_568311.host, call_568311.base,
                         call_568311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568311, url, valid)

proc call*(call_568312: Call_DatabasesGetDatabase_568302;
          resourceGroupName: string; subscriptionId: string; databaseName: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## databasesGetDatabase
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   databaseName: string (required)
  ##               : Unique name of a database in Azure migration hub.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_568313 = newJObject()
  var query_568314 = newJObject()
  add(path_568313, "resourceGroupName", newJString(resourceGroupName))
  add(query_568314, "api-version", newJString(apiVersion))
  add(path_568313, "subscriptionId", newJString(subscriptionId))
  add(path_568313, "databaseName", newJString(databaseName))
  add(path_568313, "migrateProjectName", newJString(migrateProjectName))
  result = call_568312.call(path_568313, query_568314, nil, nil, nil)

var databasesGetDatabase* = Call_DatabasesGetDatabase_568302(
    name: "databasesGetDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/databases/{databaseName}",
    validator: validate_DatabasesGetDatabase_568303, base: "",
    url: url_DatabasesGetDatabase_568304, schemes: {Scheme.Https})
type
  Call_MachinesEnumerateMachines_568315 = ref object of OpenApiRestCall_567667
proc url_MachinesEnumerateMachines_568317(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/machines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesEnumerateMachines_568316(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568318 = path.getOrDefault("resourceGroupName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "resourceGroupName", valid_568318
  var valid_568319 = path.getOrDefault("subscriptionId")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "subscriptionId", valid_568319
  var valid_568320 = path.getOrDefault("migrateProjectName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "migrateProjectName", valid_568320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  ##   continuationToken: JString
  ##                    : The continuation token.
  ##   pageSize: JInt
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568321 = query.getOrDefault("api-version")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568321 != nil:
    section.add "api-version", valid_568321
  var valid_568322 = query.getOrDefault("continuationToken")
  valid_568322 = validateParameter(valid_568322, JString, required = false,
                                 default = nil)
  if valid_568322 != nil:
    section.add "continuationToken", valid_568322
  var valid_568323 = query.getOrDefault("pageSize")
  valid_568323 = validateParameter(valid_568323, JInt, required = false, default = nil)
  if valid_568323 != nil:
    section.add "pageSize", valid_568323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568324: Call_MachinesEnumerateMachines_568315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568324.validator(path, query, header, formData, body)
  let scheme = call_568324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568324.url(scheme.get, call_568324.host, call_568324.base,
                         call_568324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568324, url, valid)

proc call*(call_568325: Call_MachinesEnumerateMachines_568315;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview";
          continuationToken: string = ""; pageSize: int = 0): Recallable =
  ## machinesEnumerateMachines
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   pageSize: int
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_568326 = newJObject()
  var query_568327 = newJObject()
  add(path_568326, "resourceGroupName", newJString(resourceGroupName))
  add(query_568327, "api-version", newJString(apiVersion))
  add(path_568326, "subscriptionId", newJString(subscriptionId))
  add(query_568327, "continuationToken", newJString(continuationToken))
  add(query_568327, "pageSize", newJInt(pageSize))
  add(path_568326, "migrateProjectName", newJString(migrateProjectName))
  result = call_568325.call(path_568326, query_568327, nil, nil, nil)

var machinesEnumerateMachines* = Call_MachinesEnumerateMachines_568315(
    name: "machinesEnumerateMachines", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/machines",
    validator: validate_MachinesEnumerateMachines_568316, base: "",
    url: url_MachinesEnumerateMachines_568317, schemes: {Scheme.Https})
type
  Call_MachinesGetMachine_568328 = ref object of OpenApiRestCall_567667
proc url_MachinesGetMachine_568330(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/machines/"),
               (kind: VariableSegment, value: "machineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesGetMachine_568329(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   machineName: JString (required)
  ##              : Unique name of a machine in Azure migration hub.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568331 = path.getOrDefault("resourceGroupName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "resourceGroupName", valid_568331
  var valid_568332 = path.getOrDefault("machineName")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "machineName", valid_568332
  var valid_568333 = path.getOrDefault("subscriptionId")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "subscriptionId", valid_568333
  var valid_568334 = path.getOrDefault("migrateProjectName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "migrateProjectName", valid_568334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568335 = query.getOrDefault("api-version")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568335 != nil:
    section.add "api-version", valid_568335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568336: Call_MachinesGetMachine_568328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568336.validator(path, query, header, formData, body)
  let scheme = call_568336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568336.url(scheme.get, call_568336.host, call_568336.base,
                         call_568336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568336, url, valid)

proc call*(call_568337: Call_MachinesGetMachine_568328; resourceGroupName: string;
          machineName: string; subscriptionId: string; migrateProjectName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## machinesGetMachine
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   machineName: string (required)
  ##              : Unique name of a machine in Azure migration hub.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_568338 = newJObject()
  var query_568339 = newJObject()
  add(path_568338, "resourceGroupName", newJString(resourceGroupName))
  add(query_568339, "api-version", newJString(apiVersion))
  add(path_568338, "machineName", newJString(machineName))
  add(path_568338, "subscriptionId", newJString(subscriptionId))
  add(path_568338, "migrateProjectName", newJString(migrateProjectName))
  result = call_568337.call(path_568338, query_568339, nil, nil, nil)

var machinesGetMachine* = Call_MachinesGetMachine_568328(
    name: "machinesGetMachine", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/machines/{machineName}",
    validator: validate_MachinesGetMachine_568329, base: "",
    url: url_MachinesGetMachine_568330, schemes: {Scheme.Https})
type
  Call_EventsEnumerateEvents_568340 = ref object of OpenApiRestCall_567667
proc url_EventsEnumerateEvents_568342(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/migrateEvents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsEnumerateEvents_568341(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568343 = path.getOrDefault("resourceGroupName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "resourceGroupName", valid_568343
  var valid_568344 = path.getOrDefault("subscriptionId")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "subscriptionId", valid_568344
  var valid_568345 = path.getOrDefault("migrateProjectName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "migrateProjectName", valid_568345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  ##   continuationToken: JString
  ##                    : The continuation token.
  ##   pageSize: JInt
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568346 = query.getOrDefault("api-version")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568346 != nil:
    section.add "api-version", valid_568346
  var valid_568347 = query.getOrDefault("continuationToken")
  valid_568347 = validateParameter(valid_568347, JString, required = false,
                                 default = nil)
  if valid_568347 != nil:
    section.add "continuationToken", valid_568347
  var valid_568348 = query.getOrDefault("pageSize")
  valid_568348 = validateParameter(valid_568348, JInt, required = false, default = nil)
  if valid_568348 != nil:
    section.add "pageSize", valid_568348
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568349 = header.getOrDefault("Accept-Language")
  valid_568349 = validateParameter(valid_568349, JString, required = false,
                                 default = nil)
  if valid_568349 != nil:
    section.add "Accept-Language", valid_568349
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568350: Call_EventsEnumerateEvents_568340; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568350.validator(path, query, header, formData, body)
  let scheme = call_568350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568350.url(scheme.get, call_568350.host, call_568350.base,
                         call_568350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568350, url, valid)

proc call*(call_568351: Call_EventsEnumerateEvents_568340;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview";
          continuationToken: string = ""; pageSize: int = 0): Recallable =
  ## eventsEnumerateEvents
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   pageSize: int
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_568352 = newJObject()
  var query_568353 = newJObject()
  add(path_568352, "resourceGroupName", newJString(resourceGroupName))
  add(query_568353, "api-version", newJString(apiVersion))
  add(path_568352, "subscriptionId", newJString(subscriptionId))
  add(query_568353, "continuationToken", newJString(continuationToken))
  add(query_568353, "pageSize", newJInt(pageSize))
  add(path_568352, "migrateProjectName", newJString(migrateProjectName))
  result = call_568351.call(path_568352, query_568353, nil, nil, nil)

var eventsEnumerateEvents* = Call_EventsEnumerateEvents_568340(
    name: "eventsEnumerateEvents", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/migrateEvents",
    validator: validate_EventsEnumerateEvents_568341, base: "",
    url: url_EventsEnumerateEvents_568342, schemes: {Scheme.Https})
type
  Call_EventsGetEvent_568354 = ref object of OpenApiRestCall_567667
proc url_EventsGetEvent_568356(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "eventName" in path, "`eventName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/migrateEvents/"),
               (kind: VariableSegment, value: "eventName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsGetEvent_568355(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   eventName: JString (required)
  ##            : Unique name of an event within a migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568357 = path.getOrDefault("resourceGroupName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "resourceGroupName", valid_568357
  var valid_568358 = path.getOrDefault("subscriptionId")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "subscriptionId", valid_568358
  var valid_568359 = path.getOrDefault("migrateProjectName")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "migrateProjectName", valid_568359
  var valid_568360 = path.getOrDefault("eventName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "eventName", valid_568360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568361 = query.getOrDefault("api-version")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568361 != nil:
    section.add "api-version", valid_568361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568362: Call_EventsGetEvent_568354; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568362.validator(path, query, header, formData, body)
  let scheme = call_568362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568362.url(scheme.get, call_568362.host, call_568362.base,
                         call_568362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568362, url, valid)

proc call*(call_568363: Call_EventsGetEvent_568354; resourceGroupName: string;
          subscriptionId: string; migrateProjectName: string; eventName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## eventsGetEvent
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   eventName: string (required)
  ##            : Unique name of an event within a migrate project.
  var path_568364 = newJObject()
  var query_568365 = newJObject()
  add(path_568364, "resourceGroupName", newJString(resourceGroupName))
  add(query_568365, "api-version", newJString(apiVersion))
  add(path_568364, "subscriptionId", newJString(subscriptionId))
  add(path_568364, "migrateProjectName", newJString(migrateProjectName))
  add(path_568364, "eventName", newJString(eventName))
  result = call_568363.call(path_568364, query_568365, nil, nil, nil)

var eventsGetEvent* = Call_EventsGetEvent_568354(name: "eventsGetEvent",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/migrateEvents/{eventName}",
    validator: validate_EventsGetEvent_568355, base: "", url: url_EventsGetEvent_568356,
    schemes: {Scheme.Https})
type
  Call_EventsDeleteEvent_568366 = ref object of OpenApiRestCall_567667
proc url_EventsDeleteEvent_568368(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "eventName" in path, "`eventName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/migrateEvents/"),
               (kind: VariableSegment, value: "eventName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsDeleteEvent_568367(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete the migrate event. Deleting non-existent migrate event is a no-operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   eventName: JString (required)
  ##            : Unique name of an event within a migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568369 = path.getOrDefault("resourceGroupName")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "resourceGroupName", valid_568369
  var valid_568370 = path.getOrDefault("subscriptionId")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "subscriptionId", valid_568370
  var valid_568371 = path.getOrDefault("migrateProjectName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "migrateProjectName", valid_568371
  var valid_568372 = path.getOrDefault("eventName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "eventName", valid_568372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568373 = query.getOrDefault("api-version")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568373 != nil:
    section.add "api-version", valid_568373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568374: Call_EventsDeleteEvent_568366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the migrate event. Deleting non-existent migrate event is a no-operation.
  ## 
  let valid = call_568374.validator(path, query, header, formData, body)
  let scheme = call_568374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568374.url(scheme.get, call_568374.host, call_568374.base,
                         call_568374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568374, url, valid)

proc call*(call_568375: Call_EventsDeleteEvent_568366; resourceGroupName: string;
          subscriptionId: string; migrateProjectName: string; eventName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## eventsDeleteEvent
  ## Delete the migrate event. Deleting non-existent migrate event is a no-operation.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   eventName: string (required)
  ##            : Unique name of an event within a migrate project.
  var path_568376 = newJObject()
  var query_568377 = newJObject()
  add(path_568376, "resourceGroupName", newJString(resourceGroupName))
  add(query_568377, "api-version", newJString(apiVersion))
  add(path_568376, "subscriptionId", newJString(subscriptionId))
  add(path_568376, "migrateProjectName", newJString(migrateProjectName))
  add(path_568376, "eventName", newJString(eventName))
  result = call_568375.call(path_568376, query_568377, nil, nil, nil)

var eventsDeleteEvent* = Call_EventsDeleteEvent_568366(name: "eventsDeleteEvent",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/migrateEvents/{eventName}",
    validator: validate_EventsDeleteEvent_568367, base: "",
    url: url_EventsDeleteEvent_568368, schemes: {Scheme.Https})
type
  Call_MigrateProjectsRefreshMigrateProjectSummary_568378 = ref object of OpenApiRestCall_567667
proc url_MigrateProjectsRefreshMigrateProjectSummary_568380(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/refreshSummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsRefreshMigrateProjectSummary_568379(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568381 = path.getOrDefault("resourceGroupName")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "resourceGroupName", valid_568381
  var valid_568382 = path.getOrDefault("subscriptionId")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "subscriptionId", valid_568382
  var valid_568383 = path.getOrDefault("migrateProjectName")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "migrateProjectName", valid_568383
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568384 = query.getOrDefault("api-version")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568384 != nil:
    section.add "api-version", valid_568384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : The goal input which needs to be refreshed.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568386: Call_MigrateProjectsRefreshMigrateProjectSummary_568378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_568386.validator(path, query, header, formData, body)
  let scheme = call_568386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568386.url(scheme.get, call_568386.host, call_568386.base,
                         call_568386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568386, url, valid)

proc call*(call_568387: Call_MigrateProjectsRefreshMigrateProjectSummary_568378;
          resourceGroupName: string; subscriptionId: string; input: JsonNode;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsRefreshMigrateProjectSummary
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   input: JObject (required)
  ##        : The goal input which needs to be refreshed.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_568388 = newJObject()
  var query_568389 = newJObject()
  var body_568390 = newJObject()
  add(path_568388, "resourceGroupName", newJString(resourceGroupName))
  add(query_568389, "api-version", newJString(apiVersion))
  add(path_568388, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_568390 = input
  add(path_568388, "migrateProjectName", newJString(migrateProjectName))
  result = call_568387.call(path_568388, query_568389, nil, nil, body_568390)

var migrateProjectsRefreshMigrateProjectSummary* = Call_MigrateProjectsRefreshMigrateProjectSummary_568378(
    name: "migrateProjectsRefreshMigrateProjectSummary",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/refreshSummary",
    validator: validate_MigrateProjectsRefreshMigrateProjectSummary_568379,
    base: "", url: url_MigrateProjectsRefreshMigrateProjectSummary_568380,
    schemes: {Scheme.Https})
type
  Call_MigrateProjectsRegisterTool_568391 = ref object of OpenApiRestCall_567667
proc url_MigrateProjectsRegisterTool_568393(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/registerTool")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsRegisterTool_568392(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568394 = path.getOrDefault("resourceGroupName")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "resourceGroupName", valid_568394
  var valid_568395 = path.getOrDefault("subscriptionId")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "subscriptionId", valid_568395
  var valid_568396 = path.getOrDefault("migrateProjectName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "migrateProjectName", valid_568396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568397 = query.getOrDefault("api-version")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568397 != nil:
    section.add "api-version", valid_568397
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568398 = header.getOrDefault("Accept-Language")
  valid_568398 = validateParameter(valid_568398, JString, required = false,
                                 default = nil)
  if valid_568398 != nil:
    section.add "Accept-Language", valid_568398
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Input containing the name of the tool to be registered.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568400: Call_MigrateProjectsRegisterTool_568391; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568400.validator(path, query, header, formData, body)
  let scheme = call_568400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568400.url(scheme.get, call_568400.host, call_568400.base,
                         call_568400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568400, url, valid)

proc call*(call_568401: Call_MigrateProjectsRegisterTool_568391;
          resourceGroupName: string; subscriptionId: string; input: JsonNode;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsRegisterTool
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   input: JObject (required)
  ##        : Input containing the name of the tool to be registered.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_568402 = newJObject()
  var query_568403 = newJObject()
  var body_568404 = newJObject()
  add(path_568402, "resourceGroupName", newJString(resourceGroupName))
  add(query_568403, "api-version", newJString(apiVersion))
  add(path_568402, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_568404 = input
  add(path_568402, "migrateProjectName", newJString(migrateProjectName))
  result = call_568401.call(path_568402, query_568403, nil, nil, body_568404)

var migrateProjectsRegisterTool* = Call_MigrateProjectsRegisterTool_568391(
    name: "migrateProjectsRegisterTool", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/registerTool",
    validator: validate_MigrateProjectsRegisterTool_568392, base: "",
    url: url_MigrateProjectsRegisterTool_568393, schemes: {Scheme.Https})
type
  Call_SolutionsEnumerateSolutions_568405 = ref object of OpenApiRestCall_567667
proc url_SolutionsEnumerateSolutions_568407(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsEnumerateSolutions_568406(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568408 = path.getOrDefault("resourceGroupName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "resourceGroupName", valid_568408
  var valid_568409 = path.getOrDefault("subscriptionId")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "subscriptionId", valid_568409
  var valid_568410 = path.getOrDefault("migrateProjectName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "migrateProjectName", valid_568410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568411 = query.getOrDefault("api-version")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568411 != nil:
    section.add "api-version", valid_568411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568412: Call_SolutionsEnumerateSolutions_568405; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568412.validator(path, query, header, formData, body)
  let scheme = call_568412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568412.url(scheme.get, call_568412.host, call_568412.base,
                         call_568412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568412, url, valid)

proc call*(call_568413: Call_SolutionsEnumerateSolutions_568405;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsEnumerateSolutions
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_568414 = newJObject()
  var query_568415 = newJObject()
  add(path_568414, "resourceGroupName", newJString(resourceGroupName))
  add(query_568415, "api-version", newJString(apiVersion))
  add(path_568414, "subscriptionId", newJString(subscriptionId))
  add(path_568414, "migrateProjectName", newJString(migrateProjectName))
  result = call_568413.call(path_568414, query_568415, nil, nil, nil)

var solutionsEnumerateSolutions* = Call_SolutionsEnumerateSolutions_568405(
    name: "solutionsEnumerateSolutions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions",
    validator: validate_SolutionsEnumerateSolutions_568406, base: "",
    url: url_SolutionsEnumerateSolutions_568407, schemes: {Scheme.Https})
type
  Call_SolutionsPutSolution_568428 = ref object of OpenApiRestCall_567667
proc url_SolutionsPutSolution_568430(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsPutSolution_568429(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568431 = path.getOrDefault("solutionName")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "solutionName", valid_568431
  var valid_568432 = path.getOrDefault("resourceGroupName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "resourceGroupName", valid_568432
  var valid_568433 = path.getOrDefault("subscriptionId")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "subscriptionId", valid_568433
  var valid_568434 = path.getOrDefault("migrateProjectName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "migrateProjectName", valid_568434
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568435 = query.getOrDefault("api-version")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568435 != nil:
    section.add "api-version", valid_568435
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   solutionInput: JObject (required)
  ##                : The input for the solution.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568437: Call_SolutionsPutSolution_568428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568437.validator(path, query, header, formData, body)
  let scheme = call_568437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568437.url(scheme.get, call_568437.host, call_568437.base,
                         call_568437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568437, url, valid)

proc call*(call_568438: Call_SolutionsPutSolution_568428; solutionName: string;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; solutionInput: JsonNode;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsPutSolution
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   solutionInput: JObject (required)
  ##                : The input for the solution.
  var path_568439 = newJObject()
  var query_568440 = newJObject()
  var body_568441 = newJObject()
  add(path_568439, "solutionName", newJString(solutionName))
  add(path_568439, "resourceGroupName", newJString(resourceGroupName))
  add(query_568440, "api-version", newJString(apiVersion))
  add(path_568439, "subscriptionId", newJString(subscriptionId))
  add(path_568439, "migrateProjectName", newJString(migrateProjectName))
  if solutionInput != nil:
    body_568441 = solutionInput
  result = call_568438.call(path_568439, query_568440, nil, nil, body_568441)

var solutionsPutSolution* = Call_SolutionsPutSolution_568428(
    name: "solutionsPutSolution", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}",
    validator: validate_SolutionsPutSolution_568429, base: "",
    url: url_SolutionsPutSolution_568430, schemes: {Scheme.Https})
type
  Call_SolutionsGetSolution_568416 = ref object of OpenApiRestCall_567667
proc url_SolutionsGetSolution_568418(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsGetSolution_568417(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568419 = path.getOrDefault("solutionName")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "solutionName", valid_568419
  var valid_568420 = path.getOrDefault("resourceGroupName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "resourceGroupName", valid_568420
  var valid_568421 = path.getOrDefault("subscriptionId")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "subscriptionId", valid_568421
  var valid_568422 = path.getOrDefault("migrateProjectName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "migrateProjectName", valid_568422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568423 = query.getOrDefault("api-version")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568423 != nil:
    section.add "api-version", valid_568423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568424: Call_SolutionsGetSolution_568416; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568424.validator(path, query, header, formData, body)
  let scheme = call_568424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568424.url(scheme.get, call_568424.host, call_568424.base,
                         call_568424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568424, url, valid)

proc call*(call_568425: Call_SolutionsGetSolution_568416; solutionName: string;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsGetSolution
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_568426 = newJObject()
  var query_568427 = newJObject()
  add(path_568426, "solutionName", newJString(solutionName))
  add(path_568426, "resourceGroupName", newJString(resourceGroupName))
  add(query_568427, "api-version", newJString(apiVersion))
  add(path_568426, "subscriptionId", newJString(subscriptionId))
  add(path_568426, "migrateProjectName", newJString(migrateProjectName))
  result = call_568425.call(path_568426, query_568427, nil, nil, nil)

var solutionsGetSolution* = Call_SolutionsGetSolution_568416(
    name: "solutionsGetSolution", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}",
    validator: validate_SolutionsGetSolution_568417, base: "",
    url: url_SolutionsGetSolution_568418, schemes: {Scheme.Https})
type
  Call_SolutionsPatchSolution_568455 = ref object of OpenApiRestCall_567667
proc url_SolutionsPatchSolution_568457(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsPatchSolution_568456(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a solution with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568458 = path.getOrDefault("solutionName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "solutionName", valid_568458
  var valid_568459 = path.getOrDefault("resourceGroupName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "resourceGroupName", valid_568459
  var valid_568460 = path.getOrDefault("subscriptionId")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "subscriptionId", valid_568460
  var valid_568461 = path.getOrDefault("migrateProjectName")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "migrateProjectName", valid_568461
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568462 = query.getOrDefault("api-version")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568462 != nil:
    section.add "api-version", valid_568462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   solutionInput: JObject (required)
  ##                : The input for the solution.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568464: Call_SolutionsPatchSolution_568455; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a solution with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  let valid = call_568464.validator(path, query, header, formData, body)
  let scheme = call_568464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568464.url(scheme.get, call_568464.host, call_568464.base,
                         call_568464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568464, url, valid)

proc call*(call_568465: Call_SolutionsPatchSolution_568455; solutionName: string;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; solutionInput: JsonNode;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsPatchSolution
  ## Update a solution with specified name. Supports partial updates, for example only tags can be provided.
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   solutionInput: JObject (required)
  ##                : The input for the solution.
  var path_568466 = newJObject()
  var query_568467 = newJObject()
  var body_568468 = newJObject()
  add(path_568466, "solutionName", newJString(solutionName))
  add(path_568466, "resourceGroupName", newJString(resourceGroupName))
  add(query_568467, "api-version", newJString(apiVersion))
  add(path_568466, "subscriptionId", newJString(subscriptionId))
  add(path_568466, "migrateProjectName", newJString(migrateProjectName))
  if solutionInput != nil:
    body_568468 = solutionInput
  result = call_568465.call(path_568466, query_568467, nil, nil, body_568468)

var solutionsPatchSolution* = Call_SolutionsPatchSolution_568455(
    name: "solutionsPatchSolution", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}",
    validator: validate_SolutionsPatchSolution_568456, base: "",
    url: url_SolutionsPatchSolution_568457, schemes: {Scheme.Https})
type
  Call_SolutionsDeleteSolution_568442 = ref object of OpenApiRestCall_567667
proc url_SolutionsDeleteSolution_568444(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsDeleteSolution_568443(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the solution. Deleting non-existent project is a no-operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568445 = path.getOrDefault("solutionName")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "solutionName", valid_568445
  var valid_568446 = path.getOrDefault("resourceGroupName")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "resourceGroupName", valid_568446
  var valid_568447 = path.getOrDefault("subscriptionId")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "subscriptionId", valid_568447
  var valid_568448 = path.getOrDefault("migrateProjectName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "migrateProjectName", valid_568448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568449 = query.getOrDefault("api-version")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568449 != nil:
    section.add "api-version", valid_568449
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568450 = header.getOrDefault("Accept-Language")
  valid_568450 = validateParameter(valid_568450, JString, required = false,
                                 default = nil)
  if valid_568450 != nil:
    section.add "Accept-Language", valid_568450
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568451: Call_SolutionsDeleteSolution_568442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the solution. Deleting non-existent project is a no-operation.
  ## 
  let valid = call_568451.validator(path, query, header, formData, body)
  let scheme = call_568451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568451.url(scheme.get, call_568451.host, call_568451.base,
                         call_568451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568451, url, valid)

proc call*(call_568452: Call_SolutionsDeleteSolution_568442; solutionName: string;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsDeleteSolution
  ## Delete the solution. Deleting non-existent project is a no-operation.
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_568453 = newJObject()
  var query_568454 = newJObject()
  add(path_568453, "solutionName", newJString(solutionName))
  add(path_568453, "resourceGroupName", newJString(resourceGroupName))
  add(query_568454, "api-version", newJString(apiVersion))
  add(path_568453, "subscriptionId", newJString(subscriptionId))
  add(path_568453, "migrateProjectName", newJString(migrateProjectName))
  result = call_568452.call(path_568453, query_568454, nil, nil, nil)

var solutionsDeleteSolution* = Call_SolutionsDeleteSolution_568442(
    name: "solutionsDeleteSolution", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}",
    validator: validate_SolutionsDeleteSolution_568443, base: "",
    url: url_SolutionsDeleteSolution_568444, schemes: {Scheme.Https})
type
  Call_SolutionsCleanupSolutionData_568469 = ref object of OpenApiRestCall_567667
proc url_SolutionsCleanupSolutionData_568471(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName"),
               (kind: ConstantSegment, value: "/cleanupData")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsCleanupSolutionData_568470(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568472 = path.getOrDefault("solutionName")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "solutionName", valid_568472
  var valid_568473 = path.getOrDefault("resourceGroupName")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "resourceGroupName", valid_568473
  var valid_568474 = path.getOrDefault("subscriptionId")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "subscriptionId", valid_568474
  var valid_568475 = path.getOrDefault("migrateProjectName")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "migrateProjectName", valid_568475
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568476 = query.getOrDefault("api-version")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568476 != nil:
    section.add "api-version", valid_568476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568477: Call_SolutionsCleanupSolutionData_568469; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568477.validator(path, query, header, formData, body)
  let scheme = call_568477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568477.url(scheme.get, call_568477.host, call_568477.base,
                         call_568477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568477, url, valid)

proc call*(call_568478: Call_SolutionsCleanupSolutionData_568469;
          solutionName: string; resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsCleanupSolutionData
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_568479 = newJObject()
  var query_568480 = newJObject()
  add(path_568479, "solutionName", newJString(solutionName))
  add(path_568479, "resourceGroupName", newJString(resourceGroupName))
  add(query_568480, "api-version", newJString(apiVersion))
  add(path_568479, "subscriptionId", newJString(subscriptionId))
  add(path_568479, "migrateProjectName", newJString(migrateProjectName))
  result = call_568478.call(path_568479, query_568480, nil, nil, nil)

var solutionsCleanupSolutionData* = Call_SolutionsCleanupSolutionData_568469(
    name: "solutionsCleanupSolutionData", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}/cleanupData",
    validator: validate_SolutionsCleanupSolutionData_568470, base: "",
    url: url_SolutionsCleanupSolutionData_568471, schemes: {Scheme.Https})
type
  Call_SolutionsGetConfig_568481 = ref object of OpenApiRestCall_567667
proc url_SolutionsGetConfig_568483(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName"),
               (kind: ConstantSegment, value: "/getConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsGetConfig_568482(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568484 = path.getOrDefault("solutionName")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "solutionName", valid_568484
  var valid_568485 = path.getOrDefault("resourceGroupName")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "resourceGroupName", valid_568485
  var valid_568486 = path.getOrDefault("subscriptionId")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "subscriptionId", valid_568486
  var valid_568487 = path.getOrDefault("migrateProjectName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "migrateProjectName", valid_568487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568488 = query.getOrDefault("api-version")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568488 != nil:
    section.add "api-version", valid_568488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568489: Call_SolutionsGetConfig_568481; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568489.validator(path, query, header, formData, body)
  let scheme = call_568489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568489.url(scheme.get, call_568489.host, call_568489.base,
                         call_568489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568489, url, valid)

proc call*(call_568490: Call_SolutionsGetConfig_568481; solutionName: string;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsGetConfig
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_568491 = newJObject()
  var query_568492 = newJObject()
  add(path_568491, "solutionName", newJString(solutionName))
  add(path_568491, "resourceGroupName", newJString(resourceGroupName))
  add(query_568492, "api-version", newJString(apiVersion))
  add(path_568491, "subscriptionId", newJString(subscriptionId))
  add(path_568491, "migrateProjectName", newJString(migrateProjectName))
  result = call_568490.call(path_568491, query_568492, nil, nil, nil)

var solutionsGetConfig* = Call_SolutionsGetConfig_568481(
    name: "solutionsGetConfig", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}/getConfig",
    validator: validate_SolutionsGetConfig_568482, base: "",
    url: url_SolutionsGetConfig_568483, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
