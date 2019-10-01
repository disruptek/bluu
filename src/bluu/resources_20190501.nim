
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ResourceManagementClient
## version: 2019-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Provides operations for working with resources and resource groups.
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
  macServiceName = "resources"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DeploymentsListAtManagementGroupScope_567889 = ref object of OpenApiRestCall_567667
proc url_DeploymentsListAtManagementGroupScope_567891(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsListAtManagementGroupScope_567890(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the deployments for a management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568065 = path.getOrDefault("groupId")
  valid_568065 = validateParameter(valid_568065, JString, required = true,
                                 default = nil)
  if valid_568065 != nil:
    section.add "groupId", valid_568065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to get. If null is passed, returns all deployments.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568066 = query.getOrDefault("api-version")
  valid_568066 = validateParameter(valid_568066, JString, required = true,
                                 default = nil)
  if valid_568066 != nil:
    section.add "api-version", valid_568066
  var valid_568067 = query.getOrDefault("$top")
  valid_568067 = validateParameter(valid_568067, JInt, required = false, default = nil)
  if valid_568067 != nil:
    section.add "$top", valid_568067
  var valid_568068 = query.getOrDefault("$filter")
  valid_568068 = validateParameter(valid_568068, JString, required = false,
                                 default = nil)
  if valid_568068 != nil:
    section.add "$filter", valid_568068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568091: Call_DeploymentsListAtManagementGroupScope_567889;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all the deployments for a management group.
  ## 
  let valid = call_568091.validator(path, query, header, formData, body)
  let scheme = call_568091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568091.url(scheme.get, call_568091.host, call_568091.base,
                         call_568091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568091, url, valid)

proc call*(call_568162: Call_DeploymentsListAtManagementGroupScope_567889;
          groupId: string; apiVersion: string; Top: int = 0; Filter: string = ""): Recallable =
  ## deploymentsListAtManagementGroupScope
  ## Get all the deployments for a management group.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Top: int
  ##      : The number of results to get. If null is passed, returns all deployments.
  ##   Filter: string
  ##         : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  var path_568163 = newJObject()
  var query_568165 = newJObject()
  add(path_568163, "groupId", newJString(groupId))
  add(query_568165, "api-version", newJString(apiVersion))
  add(query_568165, "$top", newJInt(Top))
  add(query_568165, "$filter", newJString(Filter))
  result = call_568162.call(path_568163, query_568165, nil, nil, nil)

var deploymentsListAtManagementGroupScope* = Call_DeploymentsListAtManagementGroupScope_567889(
    name: "deploymentsListAtManagementGroupScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/",
    validator: validate_DeploymentsListAtManagementGroupScope_567890, base: "",
    url: url_DeploymentsListAtManagementGroupScope_567891, schemes: {Scheme.Https})
type
  Call_DeploymentsCreateOrUpdateAtManagementGroupScope_568214 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCreateOrUpdateAtManagementGroupScope_568216(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCreateOrUpdateAtManagementGroupScope_568215(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568234 = path.getOrDefault("groupId")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "groupId", valid_568234
  var valid_568235 = path.getOrDefault("deploymentName")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "deploymentName", valid_568235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568236 = query.getOrDefault("api-version")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "api-version", valid_568236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568238: Call_DeploymentsCreateOrUpdateAtManagementGroupScope_568214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  let valid = call_568238.validator(path, query, header, formData, body)
  let scheme = call_568238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568238.url(scheme.get, call_568238.host, call_568238.base,
                         call_568238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568238, url, valid)

proc call*(call_568239: Call_DeploymentsCreateOrUpdateAtManagementGroupScope_568214;
          groupId: string; apiVersion: string; deploymentName: string;
          parameters: JsonNode): Recallable =
  ## deploymentsCreateOrUpdateAtManagementGroupScope
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  var path_568240 = newJObject()
  var query_568241 = newJObject()
  var body_568242 = newJObject()
  add(path_568240, "groupId", newJString(groupId))
  add(query_568241, "api-version", newJString(apiVersion))
  add(path_568240, "deploymentName", newJString(deploymentName))
  if parameters != nil:
    body_568242 = parameters
  result = call_568239.call(path_568240, query_568241, nil, nil, body_568242)

var deploymentsCreateOrUpdateAtManagementGroupScope* = Call_DeploymentsCreateOrUpdateAtManagementGroupScope_568214(
    name: "deploymentsCreateOrUpdateAtManagementGroupScope",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCreateOrUpdateAtManagementGroupScope_568215,
    base: "", url: url_DeploymentsCreateOrUpdateAtManagementGroupScope_568216,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCheckExistenceAtManagementGroupScope_568253 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCheckExistenceAtManagementGroupScope_568255(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCheckExistenceAtManagementGroupScope_568254(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Checks whether the deployment exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568256 = path.getOrDefault("groupId")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "groupId", valid_568256
  var valid_568257 = path.getOrDefault("deploymentName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "deploymentName", valid_568257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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

proc call*(call_568259: Call_DeploymentsCheckExistenceAtManagementGroupScope_568253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether the deployment exists.
  ## 
  let valid = call_568259.validator(path, query, header, formData, body)
  let scheme = call_568259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568259.url(scheme.get, call_568259.host, call_568259.base,
                         call_568259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568259, url, valid)

proc call*(call_568260: Call_DeploymentsCheckExistenceAtManagementGroupScope_568253;
          groupId: string; apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsCheckExistenceAtManagementGroupScope
  ## Checks whether the deployment exists.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_568261 = newJObject()
  var query_568262 = newJObject()
  add(path_568261, "groupId", newJString(groupId))
  add(query_568262, "api-version", newJString(apiVersion))
  add(path_568261, "deploymentName", newJString(deploymentName))
  result = call_568260.call(path_568261, query_568262, nil, nil, nil)

var deploymentsCheckExistenceAtManagementGroupScope* = Call_DeploymentsCheckExistenceAtManagementGroupScope_568253(
    name: "deploymentsCheckExistenceAtManagementGroupScope",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCheckExistenceAtManagementGroupScope_568254,
    base: "", url: url_DeploymentsCheckExistenceAtManagementGroupScope_568255,
    schemes: {Scheme.Https})
type
  Call_DeploymentsGetAtManagementGroupScope_568204 = ref object of OpenApiRestCall_567667
proc url_DeploymentsGetAtManagementGroupScope_568206(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsGetAtManagementGroupScope_568205(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568207 = path.getOrDefault("groupId")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "groupId", valid_568207
  var valid_568208 = path.getOrDefault("deploymentName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "deploymentName", valid_568208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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

proc call*(call_568210: Call_DeploymentsGetAtManagementGroupScope_568204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a deployment.
  ## 
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_DeploymentsGetAtManagementGroupScope_568204;
          groupId: string; apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsGetAtManagementGroupScope
  ## Gets a deployment.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_568212 = newJObject()
  var query_568213 = newJObject()
  add(path_568212, "groupId", newJString(groupId))
  add(query_568213, "api-version", newJString(apiVersion))
  add(path_568212, "deploymentName", newJString(deploymentName))
  result = call_568211.call(path_568212, query_568213, nil, nil, nil)

var deploymentsGetAtManagementGroupScope* = Call_DeploymentsGetAtManagementGroupScope_568204(
    name: "deploymentsGetAtManagementGroupScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsGetAtManagementGroupScope_568205, base: "",
    url: url_DeploymentsGetAtManagementGroupScope_568206, schemes: {Scheme.Https})
type
  Call_DeploymentsDeleteAtManagementGroupScope_568243 = ref object of OpenApiRestCall_567667
proc url_DeploymentsDeleteAtManagementGroupScope_568245(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsDeleteAtManagementGroupScope_568244(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568246 = path.getOrDefault("groupId")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "groupId", valid_568246
  var valid_568247 = path.getOrDefault("deploymentName")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "deploymentName", valid_568247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568248 = query.getOrDefault("api-version")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "api-version", valid_568248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568249: Call_DeploymentsDeleteAtManagementGroupScope_568243;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  let valid = call_568249.validator(path, query, header, formData, body)
  let scheme = call_568249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568249.url(scheme.get, call_568249.host, call_568249.base,
                         call_568249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568249, url, valid)

proc call*(call_568250: Call_DeploymentsDeleteAtManagementGroupScope_568243;
          groupId: string; apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsDeleteAtManagementGroupScope
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_568251 = newJObject()
  var query_568252 = newJObject()
  add(path_568251, "groupId", newJString(groupId))
  add(query_568252, "api-version", newJString(apiVersion))
  add(path_568251, "deploymentName", newJString(deploymentName))
  result = call_568250.call(path_568251, query_568252, nil, nil, nil)

var deploymentsDeleteAtManagementGroupScope* = Call_DeploymentsDeleteAtManagementGroupScope_568243(
    name: "deploymentsDeleteAtManagementGroupScope", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsDeleteAtManagementGroupScope_568244, base: "",
    url: url_DeploymentsDeleteAtManagementGroupScope_568245,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCancelAtManagementGroupScope_568263 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCancelAtManagementGroupScope_568265(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCancelAtManagementGroupScope_568264(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568266 = path.getOrDefault("groupId")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "groupId", valid_568266
  var valid_568267 = path.getOrDefault("deploymentName")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "deploymentName", valid_568267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568268 = query.getOrDefault("api-version")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "api-version", valid_568268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568269: Call_DeploymentsCancelAtManagementGroupScope_568263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ## 
  let valid = call_568269.validator(path, query, header, formData, body)
  let scheme = call_568269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568269.url(scheme.get, call_568269.host, call_568269.base,
                         call_568269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568269, url, valid)

proc call*(call_568270: Call_DeploymentsCancelAtManagementGroupScope_568263;
          groupId: string; apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsCancelAtManagementGroupScope
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_568271 = newJObject()
  var query_568272 = newJObject()
  add(path_568271, "groupId", newJString(groupId))
  add(query_568272, "api-version", newJString(apiVersion))
  add(path_568271, "deploymentName", newJString(deploymentName))
  result = call_568270.call(path_568271, query_568272, nil, nil, nil)

var deploymentsCancelAtManagementGroupScope* = Call_DeploymentsCancelAtManagementGroupScope_568263(
    name: "deploymentsCancelAtManagementGroupScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}/cancel",
    validator: validate_DeploymentsCancelAtManagementGroupScope_568264, base: "",
    url: url_DeploymentsCancelAtManagementGroupScope_568265,
    schemes: {Scheme.Https})
type
  Call_DeploymentsExportTemplateAtManagementGroupScope_568273 = ref object of OpenApiRestCall_567667
proc url_DeploymentsExportTemplateAtManagementGroupScope_568275(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/exportTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsExportTemplateAtManagementGroupScope_568274(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Exports the template used for specified deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568276 = path.getOrDefault("groupId")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "groupId", valid_568276
  var valid_568277 = path.getOrDefault("deploymentName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "deploymentName", valid_568277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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

proc call*(call_568279: Call_DeploymentsExportTemplateAtManagementGroupScope_568273;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Exports the template used for specified deployment.
  ## 
  let valid = call_568279.validator(path, query, header, formData, body)
  let scheme = call_568279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568279.url(scheme.get, call_568279.host, call_568279.base,
                         call_568279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568279, url, valid)

proc call*(call_568280: Call_DeploymentsExportTemplateAtManagementGroupScope_568273;
          groupId: string; apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsExportTemplateAtManagementGroupScope
  ## Exports the template used for specified deployment.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_568281 = newJObject()
  var query_568282 = newJObject()
  add(path_568281, "groupId", newJString(groupId))
  add(query_568282, "api-version", newJString(apiVersion))
  add(path_568281, "deploymentName", newJString(deploymentName))
  result = call_568280.call(path_568281, query_568282, nil, nil, nil)

var deploymentsExportTemplateAtManagementGroupScope* = Call_DeploymentsExportTemplateAtManagementGroupScope_568273(
    name: "deploymentsExportTemplateAtManagementGroupScope",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}/exportTemplate",
    validator: validate_DeploymentsExportTemplateAtManagementGroupScope_568274,
    base: "", url: url_DeploymentsExportTemplateAtManagementGroupScope_568275,
    schemes: {Scheme.Https})
type
  Call_DeploymentOperationsListAtManagementGroupScope_568283 = ref object of OpenApiRestCall_567667
proc url_DeploymentOperationsListAtManagementGroupScope_568285(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsListAtManagementGroupScope_568284(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets all deployments operations for a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568286 = path.getOrDefault("groupId")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "groupId", valid_568286
  var valid_568287 = path.getOrDefault("deploymentName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "deploymentName", valid_568287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568288 = query.getOrDefault("api-version")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "api-version", valid_568288
  var valid_568289 = query.getOrDefault("$top")
  valid_568289 = validateParameter(valid_568289, JInt, required = false, default = nil)
  if valid_568289 != nil:
    section.add "$top", valid_568289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568290: Call_DeploymentOperationsListAtManagementGroupScope_568283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments operations for a deployment.
  ## 
  let valid = call_568290.validator(path, query, header, formData, body)
  let scheme = call_568290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568290.url(scheme.get, call_568290.host, call_568290.base,
                         call_568290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568290, url, valid)

proc call*(call_568291: Call_DeploymentOperationsListAtManagementGroupScope_568283;
          groupId: string; apiVersion: string; deploymentName: string; Top: int = 0): Recallable =
  ## deploymentOperationsListAtManagementGroupScope
  ## Gets all deployments operations for a deployment.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   Top: int
  ##      : The number of results to return.
  var path_568292 = newJObject()
  var query_568293 = newJObject()
  add(path_568292, "groupId", newJString(groupId))
  add(query_568293, "api-version", newJString(apiVersion))
  add(path_568292, "deploymentName", newJString(deploymentName))
  add(query_568293, "$top", newJInt(Top))
  result = call_568291.call(path_568292, query_568293, nil, nil, nil)

var deploymentOperationsListAtManagementGroupScope* = Call_DeploymentOperationsListAtManagementGroupScope_568283(
    name: "deploymentOperationsListAtManagementGroupScope",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}/operations",
    validator: validate_DeploymentOperationsListAtManagementGroupScope_568284,
    base: "", url: url_DeploymentOperationsListAtManagementGroupScope_568285,
    schemes: {Scheme.Https})
type
  Call_DeploymentOperationsGetAtManagementGroupScope_568294 = ref object of OpenApiRestCall_567667
proc url_DeploymentOperationsGetAtManagementGroupScope_568296(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsGetAtManagementGroupScope_568295(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a deployments operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   operationId: JString (required)
  ##              : The ID of the operation to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568297 = path.getOrDefault("groupId")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "groupId", valid_568297
  var valid_568298 = path.getOrDefault("deploymentName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "deploymentName", valid_568298
  var valid_568299 = path.getOrDefault("operationId")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "operationId", valid_568299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568300 = query.getOrDefault("api-version")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "api-version", valid_568300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568301: Call_DeploymentOperationsGetAtManagementGroupScope_568294;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a deployments operation.
  ## 
  let valid = call_568301.validator(path, query, header, formData, body)
  let scheme = call_568301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568301.url(scheme.get, call_568301.host, call_568301.base,
                         call_568301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568301, url, valid)

proc call*(call_568302: Call_DeploymentOperationsGetAtManagementGroupScope_568294;
          groupId: string; apiVersion: string; deploymentName: string;
          operationId: string): Recallable =
  ## deploymentOperationsGetAtManagementGroupScope
  ## Gets a deployments operation.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   operationId: string (required)
  ##              : The ID of the operation to get.
  var path_568303 = newJObject()
  var query_568304 = newJObject()
  add(path_568303, "groupId", newJString(groupId))
  add(query_568304, "api-version", newJString(apiVersion))
  add(path_568303, "deploymentName", newJString(deploymentName))
  add(path_568303, "operationId", newJString(operationId))
  result = call_568302.call(path_568303, query_568304, nil, nil, nil)

var deploymentOperationsGetAtManagementGroupScope* = Call_DeploymentOperationsGetAtManagementGroupScope_568294(
    name: "deploymentOperationsGetAtManagementGroupScope",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}/operations/{operationId}",
    validator: validate_DeploymentOperationsGetAtManagementGroupScope_568295,
    base: "", url: url_DeploymentOperationsGetAtManagementGroupScope_568296,
    schemes: {Scheme.Https})
type
  Call_DeploymentsValidateAtManagementGroupScope_568305 = ref object of OpenApiRestCall_567667
proc url_DeploymentsValidateAtManagementGroupScope_568307(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsValidateAtManagementGroupScope_568306(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568308 = path.getOrDefault("groupId")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "groupId", valid_568308
  var valid_568309 = path.getOrDefault("deploymentName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "deploymentName", valid_568309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568310 = query.getOrDefault("api-version")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "api-version", valid_568310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568312: Call_DeploymentsValidateAtManagementGroupScope_568305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  let valid = call_568312.validator(path, query, header, formData, body)
  let scheme = call_568312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568312.url(scheme.get, call_568312.host, call_568312.base,
                         call_568312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568312, url, valid)

proc call*(call_568313: Call_DeploymentsValidateAtManagementGroupScope_568305;
          groupId: string; apiVersion: string; deploymentName: string;
          parameters: JsonNode): Recallable =
  ## deploymentsValidateAtManagementGroupScope
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  var path_568314 = newJObject()
  var query_568315 = newJObject()
  var body_568316 = newJObject()
  add(path_568314, "groupId", newJString(groupId))
  add(query_568315, "api-version", newJString(apiVersion))
  add(path_568314, "deploymentName", newJString(deploymentName))
  if parameters != nil:
    body_568316 = parameters
  result = call_568313.call(path_568314, query_568315, nil, nil, body_568316)

var deploymentsValidateAtManagementGroupScope* = Call_DeploymentsValidateAtManagementGroupScope_568305(
    name: "deploymentsValidateAtManagementGroupScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}/validate",
    validator: validate_DeploymentsValidateAtManagementGroupScope_568306,
    base: "", url: url_DeploymentsValidateAtManagementGroupScope_568307,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCalculateTemplateHash_568317 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCalculateTemplateHash_568319(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DeploymentsCalculateTemplateHash_568318(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Calculate the hash of the given template.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568320 = query.getOrDefault("api-version")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "api-version", valid_568320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   template: JObject (required)
  ##           : The template provided to calculate hash.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568322: Call_DeploymentsCalculateTemplateHash_568317;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Calculate the hash of the given template.
  ## 
  let valid = call_568322.validator(path, query, header, formData, body)
  let scheme = call_568322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568322.url(scheme.get, call_568322.host, call_568322.base,
                         call_568322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568322, url, valid)

proc call*(call_568323: Call_DeploymentsCalculateTemplateHash_568317;
          apiVersion: string; `template`: JsonNode): Recallable =
  ## deploymentsCalculateTemplateHash
  ## Calculate the hash of the given template.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   template: JObject (required)
  ##           : The template provided to calculate hash.
  var query_568324 = newJObject()
  var body_568325 = newJObject()
  add(query_568324, "api-version", newJString(apiVersion))
  if `template` != nil:
    body_568325 = `template`
  result = call_568323.call(nil, query_568324, nil, nil, body_568325)

var deploymentsCalculateTemplateHash* = Call_DeploymentsCalculateTemplateHash_568317(
    name: "deploymentsCalculateTemplateHash", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Resources/calculateTemplateHash",
    validator: validate_DeploymentsCalculateTemplateHash_568318, base: "",
    url: url_DeploymentsCalculateTemplateHash_568319, schemes: {Scheme.Https})
type
  Call_OperationsList_568326 = ref object of OpenApiRestCall_567667
proc url_OperationsList_568328(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_568327(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Microsoft.Resources REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568329 = query.getOrDefault("api-version")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "api-version", valid_568329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568330: Call_OperationsList_568326; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.Resources REST API operations.
  ## 
  let valid = call_568330.validator(path, query, header, formData, body)
  let scheme = call_568330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568330.url(scheme.get, call_568330.host, call_568330.base,
                         call_568330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568330, url, valid)

proc call*(call_568331: Call_OperationsList_568326; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Microsoft.Resources REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  var query_568332 = newJObject()
  add(query_568332, "api-version", newJString(apiVersion))
  result = call_568331.call(nil, query_568332, nil, nil, nil)

var operationsList* = Call_OperationsList_568326(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Resources/operations",
    validator: validate_OperationsList_568327, base: "", url: url_OperationsList_568328,
    schemes: {Scheme.Https})
type
  Call_ProvidersList_568333 = ref object of OpenApiRestCall_567667
proc url_ProvidersList_568335(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersList_568334(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all resource providers for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568336 = path.getOrDefault("subscriptionId")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "subscriptionId", valid_568336
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The properties to include in the results. For example, use &$expand=metadata in the query string to retrieve resource provider metadata. To include property aliases in response, use $expand=resourceTypes/aliases.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed returns all deployments.
  section = newJObject()
  var valid_568337 = query.getOrDefault("$expand")
  valid_568337 = validateParameter(valid_568337, JString, required = false,
                                 default = nil)
  if valid_568337 != nil:
    section.add "$expand", valid_568337
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568338 = query.getOrDefault("api-version")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "api-version", valid_568338
  var valid_568339 = query.getOrDefault("$top")
  valid_568339 = validateParameter(valid_568339, JInt, required = false, default = nil)
  if valid_568339 != nil:
    section.add "$top", valid_568339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568340: Call_ProvidersList_568333; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all resource providers for a subscription.
  ## 
  let valid = call_568340.validator(path, query, header, formData, body)
  let scheme = call_568340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568340.url(scheme.get, call_568340.host, call_568340.base,
                         call_568340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568340, url, valid)

proc call*(call_568341: Call_ProvidersList_568333; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0): Recallable =
  ## providersList
  ## Gets all resource providers for a subscription.
  ##   Expand: string
  ##         : The properties to include in the results. For example, use &$expand=metadata in the query string to retrieve resource provider metadata. To include property aliases in response, use $expand=resourceTypes/aliases.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return. If null is passed returns all deployments.
  var path_568342 = newJObject()
  var query_568343 = newJObject()
  add(query_568343, "$expand", newJString(Expand))
  add(query_568343, "api-version", newJString(apiVersion))
  add(path_568342, "subscriptionId", newJString(subscriptionId))
  add(query_568343, "$top", newJInt(Top))
  result = call_568341.call(path_568342, query_568343, nil, nil, nil)

var providersList* = Call_ProvidersList_568333(name: "providersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers",
    validator: validate_ProvidersList_568334, base: "", url: url_ProvidersList_568335,
    schemes: {Scheme.Https})
type
  Call_DeploymentsListAtSubscriptionScope_568344 = ref object of OpenApiRestCall_567667
proc url_DeploymentsListAtSubscriptionScope_568346(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Resources/deployments/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsListAtSubscriptionScope_568345(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the deployments for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568347 = path.getOrDefault("subscriptionId")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "subscriptionId", valid_568347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to get. If null is passed, returns all deployments.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568348 = query.getOrDefault("api-version")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "api-version", valid_568348
  var valid_568349 = query.getOrDefault("$top")
  valid_568349 = validateParameter(valid_568349, JInt, required = false, default = nil)
  if valid_568349 != nil:
    section.add "$top", valid_568349
  var valid_568350 = query.getOrDefault("$filter")
  valid_568350 = validateParameter(valid_568350, JString, required = false,
                                 default = nil)
  if valid_568350 != nil:
    section.add "$filter", valid_568350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568351: Call_DeploymentsListAtSubscriptionScope_568344;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all the deployments for a subscription.
  ## 
  let valid = call_568351.validator(path, query, header, formData, body)
  let scheme = call_568351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568351.url(scheme.get, call_568351.host, call_568351.base,
                         call_568351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568351, url, valid)

proc call*(call_568352: Call_DeploymentsListAtSubscriptionScope_568344;
          apiVersion: string; subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## deploymentsListAtSubscriptionScope
  ## Get all the deployments for a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to get. If null is passed, returns all deployments.
  ##   Filter: string
  ##         : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  var path_568353 = newJObject()
  var query_568354 = newJObject()
  add(query_568354, "api-version", newJString(apiVersion))
  add(path_568353, "subscriptionId", newJString(subscriptionId))
  add(query_568354, "$top", newJInt(Top))
  add(query_568354, "$filter", newJString(Filter))
  result = call_568352.call(path_568353, query_568354, nil, nil, nil)

var deploymentsListAtSubscriptionScope* = Call_DeploymentsListAtSubscriptionScope_568344(
    name: "deploymentsListAtSubscriptionScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/",
    validator: validate_DeploymentsListAtSubscriptionScope_568345, base: "",
    url: url_DeploymentsListAtSubscriptionScope_568346, schemes: {Scheme.Https})
type
  Call_DeploymentsCreateOrUpdateAtSubscriptionScope_568365 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCreateOrUpdateAtSubscriptionScope_568367(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCreateOrUpdateAtSubscriptionScope_568366(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568368 = path.getOrDefault("deploymentName")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "deploymentName", valid_568368
  var valid_568369 = path.getOrDefault("subscriptionId")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "subscriptionId", valid_568369
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568370 = query.getOrDefault("api-version")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "api-version", valid_568370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568372: Call_DeploymentsCreateOrUpdateAtSubscriptionScope_568365;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  let valid = call_568372.validator(path, query, header, formData, body)
  let scheme = call_568372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568372.url(scheme.get, call_568372.host, call_568372.base,
                         call_568372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568372, url, valid)

proc call*(call_568373: Call_DeploymentsCreateOrUpdateAtSubscriptionScope_568365;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## deploymentsCreateOrUpdateAtSubscriptionScope
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  var path_568374 = newJObject()
  var query_568375 = newJObject()
  var body_568376 = newJObject()
  add(query_568375, "api-version", newJString(apiVersion))
  add(path_568374, "deploymentName", newJString(deploymentName))
  add(path_568374, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568376 = parameters
  result = call_568373.call(path_568374, query_568375, nil, nil, body_568376)

var deploymentsCreateOrUpdateAtSubscriptionScope* = Call_DeploymentsCreateOrUpdateAtSubscriptionScope_568365(
    name: "deploymentsCreateOrUpdateAtSubscriptionScope",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCreateOrUpdateAtSubscriptionScope_568366,
    base: "", url: url_DeploymentsCreateOrUpdateAtSubscriptionScope_568367,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCheckExistenceAtSubscriptionScope_568387 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCheckExistenceAtSubscriptionScope_568389(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCheckExistenceAtSubscriptionScope_568388(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the deployment exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568390 = path.getOrDefault("deploymentName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "deploymentName", valid_568390
  var valid_568391 = path.getOrDefault("subscriptionId")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "subscriptionId", valid_568391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568392 = query.getOrDefault("api-version")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "api-version", valid_568392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568393: Call_DeploymentsCheckExistenceAtSubscriptionScope_568387;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether the deployment exists.
  ## 
  let valid = call_568393.validator(path, query, header, formData, body)
  let scheme = call_568393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568393.url(scheme.get, call_568393.host, call_568393.base,
                         call_568393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568393, url, valid)

proc call*(call_568394: Call_DeploymentsCheckExistenceAtSubscriptionScope_568387;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsCheckExistenceAtSubscriptionScope
  ## Checks whether the deployment exists.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568395 = newJObject()
  var query_568396 = newJObject()
  add(query_568396, "api-version", newJString(apiVersion))
  add(path_568395, "deploymentName", newJString(deploymentName))
  add(path_568395, "subscriptionId", newJString(subscriptionId))
  result = call_568394.call(path_568395, query_568396, nil, nil, nil)

var deploymentsCheckExistenceAtSubscriptionScope* = Call_DeploymentsCheckExistenceAtSubscriptionScope_568387(
    name: "deploymentsCheckExistenceAtSubscriptionScope",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCheckExistenceAtSubscriptionScope_568388,
    base: "", url: url_DeploymentsCheckExistenceAtSubscriptionScope_568389,
    schemes: {Scheme.Https})
type
  Call_DeploymentsGetAtSubscriptionScope_568355 = ref object of OpenApiRestCall_567667
proc url_DeploymentsGetAtSubscriptionScope_568357(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsGetAtSubscriptionScope_568356(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568358 = path.getOrDefault("deploymentName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "deploymentName", valid_568358
  var valid_568359 = path.getOrDefault("subscriptionId")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "subscriptionId", valid_568359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568360 = query.getOrDefault("api-version")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "api-version", valid_568360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568361: Call_DeploymentsGetAtSubscriptionScope_568355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a deployment.
  ## 
  let valid = call_568361.validator(path, query, header, formData, body)
  let scheme = call_568361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568361.url(scheme.get, call_568361.host, call_568361.base,
                         call_568361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568361, url, valid)

proc call*(call_568362: Call_DeploymentsGetAtSubscriptionScope_568355;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsGetAtSubscriptionScope
  ## Gets a deployment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568363 = newJObject()
  var query_568364 = newJObject()
  add(query_568364, "api-version", newJString(apiVersion))
  add(path_568363, "deploymentName", newJString(deploymentName))
  add(path_568363, "subscriptionId", newJString(subscriptionId))
  result = call_568362.call(path_568363, query_568364, nil, nil, nil)

var deploymentsGetAtSubscriptionScope* = Call_DeploymentsGetAtSubscriptionScope_568355(
    name: "deploymentsGetAtSubscriptionScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsGetAtSubscriptionScope_568356, base: "",
    url: url_DeploymentsGetAtSubscriptionScope_568357, schemes: {Scheme.Https})
type
  Call_DeploymentsDeleteAtSubscriptionScope_568377 = ref object of OpenApiRestCall_567667
proc url_DeploymentsDeleteAtSubscriptionScope_568379(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsDeleteAtSubscriptionScope_568378(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568380 = path.getOrDefault("deploymentName")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "deploymentName", valid_568380
  var valid_568381 = path.getOrDefault("subscriptionId")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "subscriptionId", valid_568381
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568382 = query.getOrDefault("api-version")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "api-version", valid_568382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568383: Call_DeploymentsDeleteAtSubscriptionScope_568377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  let valid = call_568383.validator(path, query, header, formData, body)
  let scheme = call_568383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568383.url(scheme.get, call_568383.host, call_568383.base,
                         call_568383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568383, url, valid)

proc call*(call_568384: Call_DeploymentsDeleteAtSubscriptionScope_568377;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsDeleteAtSubscriptionScope
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568385 = newJObject()
  var query_568386 = newJObject()
  add(query_568386, "api-version", newJString(apiVersion))
  add(path_568385, "deploymentName", newJString(deploymentName))
  add(path_568385, "subscriptionId", newJString(subscriptionId))
  result = call_568384.call(path_568385, query_568386, nil, nil, nil)

var deploymentsDeleteAtSubscriptionScope* = Call_DeploymentsDeleteAtSubscriptionScope_568377(
    name: "deploymentsDeleteAtSubscriptionScope", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsDeleteAtSubscriptionScope_568378, base: "",
    url: url_DeploymentsDeleteAtSubscriptionScope_568379, schemes: {Scheme.Https})
type
  Call_DeploymentsCancelAtSubscriptionScope_568397 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCancelAtSubscriptionScope_568399(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCancelAtSubscriptionScope_568398(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568400 = path.getOrDefault("deploymentName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "deploymentName", valid_568400
  var valid_568401 = path.getOrDefault("subscriptionId")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "subscriptionId", valid_568401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568402 = query.getOrDefault("api-version")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "api-version", valid_568402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568403: Call_DeploymentsCancelAtSubscriptionScope_568397;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ## 
  let valid = call_568403.validator(path, query, header, formData, body)
  let scheme = call_568403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568403.url(scheme.get, call_568403.host, call_568403.base,
                         call_568403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568403, url, valid)

proc call*(call_568404: Call_DeploymentsCancelAtSubscriptionScope_568397;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsCancelAtSubscriptionScope
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568405 = newJObject()
  var query_568406 = newJObject()
  add(query_568406, "api-version", newJString(apiVersion))
  add(path_568405, "deploymentName", newJString(deploymentName))
  add(path_568405, "subscriptionId", newJString(subscriptionId))
  result = call_568404.call(path_568405, query_568406, nil, nil, nil)

var deploymentsCancelAtSubscriptionScope* = Call_DeploymentsCancelAtSubscriptionScope_568397(
    name: "deploymentsCancelAtSubscriptionScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/cancel",
    validator: validate_DeploymentsCancelAtSubscriptionScope_568398, base: "",
    url: url_DeploymentsCancelAtSubscriptionScope_568399, schemes: {Scheme.Https})
type
  Call_DeploymentsExportTemplateAtSubscriptionScope_568407 = ref object of OpenApiRestCall_567667
proc url_DeploymentsExportTemplateAtSubscriptionScope_568409(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/exportTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsExportTemplateAtSubscriptionScope_568408(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports the template used for specified deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568410 = path.getOrDefault("deploymentName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "deploymentName", valid_568410
  var valid_568411 = path.getOrDefault("subscriptionId")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "subscriptionId", valid_568411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568412 = query.getOrDefault("api-version")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "api-version", valid_568412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568413: Call_DeploymentsExportTemplateAtSubscriptionScope_568407;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Exports the template used for specified deployment.
  ## 
  let valid = call_568413.validator(path, query, header, formData, body)
  let scheme = call_568413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568413.url(scheme.get, call_568413.host, call_568413.base,
                         call_568413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568413, url, valid)

proc call*(call_568414: Call_DeploymentsExportTemplateAtSubscriptionScope_568407;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsExportTemplateAtSubscriptionScope
  ## Exports the template used for specified deployment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568415 = newJObject()
  var query_568416 = newJObject()
  add(query_568416, "api-version", newJString(apiVersion))
  add(path_568415, "deploymentName", newJString(deploymentName))
  add(path_568415, "subscriptionId", newJString(subscriptionId))
  result = call_568414.call(path_568415, query_568416, nil, nil, nil)

var deploymentsExportTemplateAtSubscriptionScope* = Call_DeploymentsExportTemplateAtSubscriptionScope_568407(
    name: "deploymentsExportTemplateAtSubscriptionScope",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/exportTemplate",
    validator: validate_DeploymentsExportTemplateAtSubscriptionScope_568408,
    base: "", url: url_DeploymentsExportTemplateAtSubscriptionScope_568409,
    schemes: {Scheme.Https})
type
  Call_DeploymentOperationsListAtSubscriptionScope_568417 = ref object of OpenApiRestCall_567667
proc url_DeploymentOperationsListAtSubscriptionScope_568419(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsListAtSubscriptionScope_568418(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all deployments operations for a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568420 = path.getOrDefault("deploymentName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "deploymentName", valid_568420
  var valid_568421 = path.getOrDefault("subscriptionId")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "subscriptionId", valid_568421
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568422 = query.getOrDefault("api-version")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "api-version", valid_568422
  var valid_568423 = query.getOrDefault("$top")
  valid_568423 = validateParameter(valid_568423, JInt, required = false, default = nil)
  if valid_568423 != nil:
    section.add "$top", valid_568423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568424: Call_DeploymentOperationsListAtSubscriptionScope_568417;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments operations for a deployment.
  ## 
  let valid = call_568424.validator(path, query, header, formData, body)
  let scheme = call_568424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568424.url(scheme.get, call_568424.host, call_568424.base,
                         call_568424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568424, url, valid)

proc call*(call_568425: Call_DeploymentOperationsListAtSubscriptionScope_568417;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          Top: int = 0): Recallable =
  ## deploymentOperationsListAtSubscriptionScope
  ## Gets all deployments operations for a deployment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return.
  var path_568426 = newJObject()
  var query_568427 = newJObject()
  add(query_568427, "api-version", newJString(apiVersion))
  add(path_568426, "deploymentName", newJString(deploymentName))
  add(path_568426, "subscriptionId", newJString(subscriptionId))
  add(query_568427, "$top", newJInt(Top))
  result = call_568425.call(path_568426, query_568427, nil, nil, nil)

var deploymentOperationsListAtSubscriptionScope* = Call_DeploymentOperationsListAtSubscriptionScope_568417(
    name: "deploymentOperationsListAtSubscriptionScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/operations",
    validator: validate_DeploymentOperationsListAtSubscriptionScope_568418,
    base: "", url: url_DeploymentOperationsListAtSubscriptionScope_568419,
    schemes: {Scheme.Https})
type
  Call_DeploymentOperationsGetAtSubscriptionScope_568428 = ref object of OpenApiRestCall_567667
proc url_DeploymentOperationsGetAtSubscriptionScope_568430(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsGetAtSubscriptionScope_568429(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployments operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   operationId: JString (required)
  ##              : The ID of the operation to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568431 = path.getOrDefault("deploymentName")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "deploymentName", valid_568431
  var valid_568432 = path.getOrDefault("subscriptionId")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "subscriptionId", valid_568432
  var valid_568433 = path.getOrDefault("operationId")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "operationId", valid_568433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568434 = query.getOrDefault("api-version")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "api-version", valid_568434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568435: Call_DeploymentOperationsGetAtSubscriptionScope_568428;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a deployments operation.
  ## 
  let valid = call_568435.validator(path, query, header, formData, body)
  let scheme = call_568435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568435.url(scheme.get, call_568435.host, call_568435.base,
                         call_568435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568435, url, valid)

proc call*(call_568436: Call_DeploymentOperationsGetAtSubscriptionScope_568428;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          operationId: string): Recallable =
  ## deploymentOperationsGetAtSubscriptionScope
  ## Gets a deployments operation.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   operationId: string (required)
  ##              : The ID of the operation to get.
  var path_568437 = newJObject()
  var query_568438 = newJObject()
  add(query_568438, "api-version", newJString(apiVersion))
  add(path_568437, "deploymentName", newJString(deploymentName))
  add(path_568437, "subscriptionId", newJString(subscriptionId))
  add(path_568437, "operationId", newJString(operationId))
  result = call_568436.call(path_568437, query_568438, nil, nil, nil)

var deploymentOperationsGetAtSubscriptionScope* = Call_DeploymentOperationsGetAtSubscriptionScope_568428(
    name: "deploymentOperationsGetAtSubscriptionScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/operations/{operationId}",
    validator: validate_DeploymentOperationsGetAtSubscriptionScope_568429,
    base: "", url: url_DeploymentOperationsGetAtSubscriptionScope_568430,
    schemes: {Scheme.Https})
type
  Call_DeploymentsValidateAtSubscriptionScope_568439 = ref object of OpenApiRestCall_567667
proc url_DeploymentsValidateAtSubscriptionScope_568441(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsValidateAtSubscriptionScope_568440(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568442 = path.getOrDefault("deploymentName")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "deploymentName", valid_568442
  var valid_568443 = path.getOrDefault("subscriptionId")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "subscriptionId", valid_568443
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568444 = query.getOrDefault("api-version")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "api-version", valid_568444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568446: Call_DeploymentsValidateAtSubscriptionScope_568439;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  let valid = call_568446.validator(path, query, header, formData, body)
  let scheme = call_568446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568446.url(scheme.get, call_568446.host, call_568446.base,
                         call_568446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568446, url, valid)

proc call*(call_568447: Call_DeploymentsValidateAtSubscriptionScope_568439;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## deploymentsValidateAtSubscriptionScope
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  var path_568448 = newJObject()
  var query_568449 = newJObject()
  var body_568450 = newJObject()
  add(query_568449, "api-version", newJString(apiVersion))
  add(path_568448, "deploymentName", newJString(deploymentName))
  add(path_568448, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568450 = parameters
  result = call_568447.call(path_568448, query_568449, nil, nil, body_568450)

var deploymentsValidateAtSubscriptionScope* = Call_DeploymentsValidateAtSubscriptionScope_568439(
    name: "deploymentsValidateAtSubscriptionScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/validate",
    validator: validate_DeploymentsValidateAtSubscriptionScope_568440, base: "",
    url: url_DeploymentsValidateAtSubscriptionScope_568441,
    schemes: {Scheme.Https})
type
  Call_ProvidersGet_568451 = ref object of OpenApiRestCall_567667
proc url_ProvidersGet_568453(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersGet_568452(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568454 = path.getOrDefault("subscriptionId")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "subscriptionId", valid_568454
  var valid_568455 = path.getOrDefault("resourceProviderNamespace")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "resourceProviderNamespace", valid_568455
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand query parameter. For example, to include property aliases in response, use $expand=resourceTypes/aliases.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  var valid_568456 = query.getOrDefault("$expand")
  valid_568456 = validateParameter(valid_568456, JString, required = false,
                                 default = nil)
  if valid_568456 != nil:
    section.add "$expand", valid_568456
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568457 = query.getOrDefault("api-version")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "api-version", valid_568457
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568458: Call_ProvidersGet_568451; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified resource provider.
  ## 
  let valid = call_568458.validator(path, query, header, formData, body)
  let scheme = call_568458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568458.url(scheme.get, call_568458.host, call_568458.base,
                         call_568458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568458, url, valid)

proc call*(call_568459: Call_ProvidersGet_568451; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string;
          Expand: string = ""): Recallable =
  ## providersGet
  ## Gets the specified resource provider.
  ##   Expand: string
  ##         : The $expand query parameter. For example, to include property aliases in response, use $expand=resourceTypes/aliases.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  var path_568460 = newJObject()
  var query_568461 = newJObject()
  add(query_568461, "$expand", newJString(Expand))
  add(query_568461, "api-version", newJString(apiVersion))
  add(path_568460, "subscriptionId", newJString(subscriptionId))
  add(path_568460, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_568459.call(path_568460, query_568461, nil, nil, nil)

var providersGet* = Call_ProvidersGet_568451(name: "providersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}",
    validator: validate_ProvidersGet_568452, base: "", url: url_ProvidersGet_568453,
    schemes: {Scheme.Https})
type
  Call_ProvidersRegister_568462 = ref object of OpenApiRestCall_567667
proc url_ProvidersRegister_568464(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/register")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersRegister_568463(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Registers a subscription with a resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider to register.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568465 = path.getOrDefault("subscriptionId")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "subscriptionId", valid_568465
  var valid_568466 = path.getOrDefault("resourceProviderNamespace")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "resourceProviderNamespace", valid_568466
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568467 = query.getOrDefault("api-version")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "api-version", valid_568467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568468: Call_ProvidersRegister_568462; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a subscription with a resource provider.
  ## 
  let valid = call_568468.validator(path, query, header, formData, body)
  let scheme = call_568468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568468.url(scheme.get, call_568468.host, call_568468.base,
                         call_568468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568468, url, valid)

proc call*(call_568469: Call_ProvidersRegister_568462; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string): Recallable =
  ## providersRegister
  ## Registers a subscription with a resource provider.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider to register.
  var path_568470 = newJObject()
  var query_568471 = newJObject()
  add(query_568471, "api-version", newJString(apiVersion))
  add(path_568470, "subscriptionId", newJString(subscriptionId))
  add(path_568470, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_568469.call(path_568470, query_568471, nil, nil, nil)

var providersRegister* = Call_ProvidersRegister_568462(name: "providersRegister",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}/register",
    validator: validate_ProvidersRegister_568463, base: "",
    url: url_ProvidersRegister_568464, schemes: {Scheme.Https})
type
  Call_ProvidersUnregister_568472 = ref object of OpenApiRestCall_567667
proc url_ProvidersUnregister_568474(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/unregister")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersUnregister_568473(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Unregisters a subscription from a resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider to unregister.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568475 = path.getOrDefault("subscriptionId")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "subscriptionId", valid_568475
  var valid_568476 = path.getOrDefault("resourceProviderNamespace")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "resourceProviderNamespace", valid_568476
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568477 = query.getOrDefault("api-version")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "api-version", valid_568477
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568478: Call_ProvidersUnregister_568472; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregisters a subscription from a resource provider.
  ## 
  let valid = call_568478.validator(path, query, header, formData, body)
  let scheme = call_568478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568478.url(scheme.get, call_568478.host, call_568478.base,
                         call_568478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568478, url, valid)

proc call*(call_568479: Call_ProvidersUnregister_568472; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string): Recallable =
  ## providersUnregister
  ## Unregisters a subscription from a resource provider.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider to unregister.
  var path_568480 = newJObject()
  var query_568481 = newJObject()
  add(query_568481, "api-version", newJString(apiVersion))
  add(path_568480, "subscriptionId", newJString(subscriptionId))
  add(path_568480, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_568479.call(path_568480, query_568481, nil, nil, nil)

var providersUnregister* = Call_ProvidersUnregister_568472(
    name: "providersUnregister", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}/unregister",
    validator: validate_ProvidersUnregister_568473, base: "",
    url: url_ProvidersUnregister_568474, schemes: {Scheme.Https})
type
  Call_ResourcesListByResourceGroup_568482 = ref object of OpenApiRestCall_567667
proc url_ResourcesListByResourceGroup_568484(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/resources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesListByResourceGroup_568483(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the resources for a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group with the resources to get.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
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
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand query parameter. You can expand createdTime and changedTime. For example, to expand both properties, use $expand=changedTime,createdTime
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed, returns all resources.
  ##   $filter: JString
  ##          : The filter to apply on the operation.<br><br>The properties you can use for eq (equals) or ne (not equals) are: location, resourceType, name, resourceGroup, identity, identity/principalId, plan, plan/publisher, plan/product, plan/name, plan/version, and plan/promotionCode.<br><br>For example, to filter by a resource type, use: $filter=resourceType eq 'Microsoft.Network/virtualNetworks'<br><br>You can use substringof(value, property) in the filter. The properties you can use for substring are: name and resourceGroup.<br><br>For example, to get all resources with 'demo' anywhere in the name, use: $filter=substringof('demo', name)<br><br>You can link more than one substringof together by adding and/or operators.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'<br><br>You can use some properties together when filtering. The combinations you can use are: substringof and/or resourceType, plan and plan/publisher and plan/name, identity and identity/principalId.
  section = newJObject()
  var valid_568487 = query.getOrDefault("$expand")
  valid_568487 = validateParameter(valid_568487, JString, required = false,
                                 default = nil)
  if valid_568487 != nil:
    section.add "$expand", valid_568487
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568488 = query.getOrDefault("api-version")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "api-version", valid_568488
  var valid_568489 = query.getOrDefault("$top")
  valid_568489 = validateParameter(valid_568489, JInt, required = false, default = nil)
  if valid_568489 != nil:
    section.add "$top", valid_568489
  var valid_568490 = query.getOrDefault("$filter")
  valid_568490 = validateParameter(valid_568490, JString, required = false,
                                 default = nil)
  if valid_568490 != nil:
    section.add "$filter", valid_568490
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568491: Call_ResourcesListByResourceGroup_568482; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the resources for a resource group.
  ## 
  let valid = call_568491.validator(path, query, header, formData, body)
  let scheme = call_568491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568491.url(scheme.get, call_568491.host, call_568491.base,
                         call_568491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568491, url, valid)

proc call*(call_568492: Call_ResourcesListByResourceGroup_568482;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Expand: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## resourcesListByResourceGroup
  ## Get all the resources for a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group with the resources to get.
  ##   Expand: string
  ##         : The $expand query parameter. You can expand createdTime and changedTime. For example, to expand both properties, use $expand=changedTime,createdTime
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return. If null is passed, returns all resources.
  ##   Filter: string
  ##         : The filter to apply on the operation.<br><br>The properties you can use for eq (equals) or ne (not equals) are: location, resourceType, name, resourceGroup, identity, identity/principalId, plan, plan/publisher, plan/product, plan/name, plan/version, and plan/promotionCode.<br><br>For example, to filter by a resource type, use: $filter=resourceType eq 'Microsoft.Network/virtualNetworks'<br><br>You can use substringof(value, property) in the filter. The properties you can use for substring are: name and resourceGroup.<br><br>For example, to get all resources with 'demo' anywhere in the name, use: $filter=substringof('demo', name)<br><br>You can link more than one substringof together by adding and/or operators.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'<br><br>You can use some properties together when filtering. The combinations you can use are: substringof and/or resourceType, plan and plan/publisher and plan/name, identity and identity/principalId.
  var path_568493 = newJObject()
  var query_568494 = newJObject()
  add(path_568493, "resourceGroupName", newJString(resourceGroupName))
  add(query_568494, "$expand", newJString(Expand))
  add(query_568494, "api-version", newJString(apiVersion))
  add(path_568493, "subscriptionId", newJString(subscriptionId))
  add(query_568494, "$top", newJInt(Top))
  add(query_568494, "$filter", newJString(Filter))
  result = call_568492.call(path_568493, query_568494, nil, nil, nil)

var resourcesListByResourceGroup* = Call_ResourcesListByResourceGroup_568482(
    name: "resourcesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/resources",
    validator: validate_ResourcesListByResourceGroup_568483, base: "",
    url: url_ResourcesListByResourceGroup_568484, schemes: {Scheme.Https})
type
  Call_ResourcesMoveResources_568495 = ref object of OpenApiRestCall_567667
proc url_ResourcesMoveResources_568497(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "sourceResourceGroupName" in path,
        "`sourceResourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "sourceResourceGroupName"),
               (kind: ConstantSegment, value: "/moveResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesMoveResources_568496(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The resources to move must be in the same source resource group. The target resource group may be in a different subscription. When moving resources, both the source group and the target group are locked for the duration of the operation. Write and delete operations are blocked on the groups until the move completes. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sourceResourceGroupName: JString (required)
  ##                          : The name of the resource group containing the resources to move.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sourceResourceGroupName` field"
  var valid_568498 = path.getOrDefault("sourceResourceGroupName")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "sourceResourceGroupName", valid_568498
  var valid_568499 = path.getOrDefault("subscriptionId")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "subscriptionId", valid_568499
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568500 = query.getOrDefault("api-version")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "api-version", valid_568500
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for moving resources.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568502: Call_ResourcesMoveResources_568495; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The resources to move must be in the same source resource group. The target resource group may be in a different subscription. When moving resources, both the source group and the target group are locked for the duration of the operation. Write and delete operations are blocked on the groups until the move completes. 
  ## 
  let valid = call_568502.validator(path, query, header, formData, body)
  let scheme = call_568502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568502.url(scheme.get, call_568502.host, call_568502.base,
                         call_568502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568502, url, valid)

proc call*(call_568503: Call_ResourcesMoveResources_568495; apiVersion: string;
          sourceResourceGroupName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## resourcesMoveResources
  ## The resources to move must be in the same source resource group. The target resource group may be in a different subscription. When moving resources, both the source group and the target group are locked for the duration of the operation. Write and delete operations are blocked on the groups until the move completes. 
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   sourceResourceGroupName: string (required)
  ##                          : The name of the resource group containing the resources to move.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters for moving resources.
  var path_568504 = newJObject()
  var query_568505 = newJObject()
  var body_568506 = newJObject()
  add(query_568505, "api-version", newJString(apiVersion))
  add(path_568504, "sourceResourceGroupName", newJString(sourceResourceGroupName))
  add(path_568504, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568506 = parameters
  result = call_568503.call(path_568504, query_568505, nil, nil, body_568506)

var resourcesMoveResources* = Call_ResourcesMoveResources_568495(
    name: "resourcesMoveResources", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{sourceResourceGroupName}/moveResources",
    validator: validate_ResourcesMoveResources_568496, base: "",
    url: url_ResourcesMoveResources_568497, schemes: {Scheme.Https})
type
  Call_ResourcesValidateMoveResources_568507 = ref object of OpenApiRestCall_567667
proc url_ResourcesValidateMoveResources_568509(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "sourceResourceGroupName" in path,
        "`sourceResourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "sourceResourceGroupName"),
               (kind: ConstantSegment, value: "/validateMoveResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesValidateMoveResources_568508(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation checks whether the specified resources can be moved to the target. The resources to move must be in the same source resource group. The target resource group may be in a different subscription. If validation succeeds, it returns HTTP response code 204 (no content). If validation fails, it returns HTTP response code 409 (Conflict) with an error message. Retrieve the URL in the Location header value to check the result of the long-running operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sourceResourceGroupName: JString (required)
  ##                          : The name of the resource group containing the resources to validate for move.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sourceResourceGroupName` field"
  var valid_568510 = path.getOrDefault("sourceResourceGroupName")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "sourceResourceGroupName", valid_568510
  var valid_568511 = path.getOrDefault("subscriptionId")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "subscriptionId", valid_568511
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568512 = query.getOrDefault("api-version")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "api-version", valid_568512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for moving resources.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568514: Call_ResourcesValidateMoveResources_568507; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation checks whether the specified resources can be moved to the target. The resources to move must be in the same source resource group. The target resource group may be in a different subscription. If validation succeeds, it returns HTTP response code 204 (no content). If validation fails, it returns HTTP response code 409 (Conflict) with an error message. Retrieve the URL in the Location header value to check the result of the long-running operation.
  ## 
  let valid = call_568514.validator(path, query, header, formData, body)
  let scheme = call_568514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568514.url(scheme.get, call_568514.host, call_568514.base,
                         call_568514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568514, url, valid)

proc call*(call_568515: Call_ResourcesValidateMoveResources_568507;
          apiVersion: string; sourceResourceGroupName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## resourcesValidateMoveResources
  ## This operation checks whether the specified resources can be moved to the target. The resources to move must be in the same source resource group. The target resource group may be in a different subscription. If validation succeeds, it returns HTTP response code 204 (no content). If validation fails, it returns HTTP response code 409 (Conflict) with an error message. Retrieve the URL in the Location header value to check the result of the long-running operation.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   sourceResourceGroupName: string (required)
  ##                          : The name of the resource group containing the resources to validate for move.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters for moving resources.
  var path_568516 = newJObject()
  var query_568517 = newJObject()
  var body_568518 = newJObject()
  add(query_568517, "api-version", newJString(apiVersion))
  add(path_568516, "sourceResourceGroupName", newJString(sourceResourceGroupName))
  add(path_568516, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568518 = parameters
  result = call_568515.call(path_568516, query_568517, nil, nil, body_568518)

var resourcesValidateMoveResources* = Call_ResourcesValidateMoveResources_568507(
    name: "resourcesValidateMoveResources", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{sourceResourceGroupName}/validateMoveResources",
    validator: validate_ResourcesValidateMoveResources_568508, base: "",
    url: url_ResourcesValidateMoveResources_568509, schemes: {Scheme.Https})
type
  Call_ResourceGroupsList_568519 = ref object of OpenApiRestCall_567667
proc url_ResourceGroupsList_568521(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsList_568520(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets all the resource groups for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568522 = path.getOrDefault("subscriptionId")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "subscriptionId", valid_568522
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed, returns all resource groups.
  ##   $filter: JString
  ##          : The filter to apply on the operation.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568523 = query.getOrDefault("api-version")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "api-version", valid_568523
  var valid_568524 = query.getOrDefault("$top")
  valid_568524 = validateParameter(valid_568524, JInt, required = false, default = nil)
  if valid_568524 != nil:
    section.add "$top", valid_568524
  var valid_568525 = query.getOrDefault("$filter")
  valid_568525 = validateParameter(valid_568525, JString, required = false,
                                 default = nil)
  if valid_568525 != nil:
    section.add "$filter", valid_568525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568526: Call_ResourceGroupsList_568519; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the resource groups for a subscription.
  ## 
  let valid = call_568526.validator(path, query, header, formData, body)
  let scheme = call_568526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568526.url(scheme.get, call_568526.host, call_568526.base,
                         call_568526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568526, url, valid)

proc call*(call_568527: Call_ResourceGroupsList_568519; apiVersion: string;
          subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## resourceGroupsList
  ## Gets all the resource groups for a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return. If null is passed, returns all resource groups.
  ##   Filter: string
  ##         : The filter to apply on the operation.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'
  var path_568528 = newJObject()
  var query_568529 = newJObject()
  add(query_568529, "api-version", newJString(apiVersion))
  add(path_568528, "subscriptionId", newJString(subscriptionId))
  add(query_568529, "$top", newJInt(Top))
  add(query_568529, "$filter", newJString(Filter))
  result = call_568527.call(path_568528, query_568529, nil, nil, nil)

var resourceGroupsList* = Call_ResourceGroupsList_568519(
    name: "resourceGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/resourcegroups",
    validator: validate_ResourceGroupsList_568520, base: "",
    url: url_ResourceGroupsList_568521, schemes: {Scheme.Https})
type
  Call_ResourceGroupsCreateOrUpdate_568540 = ref object of OpenApiRestCall_567667
proc url_ResourceGroupsCreateOrUpdate_568542(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsCreateOrUpdate_568541(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to create or update. Can include alphanumeric, underscore, parentheses, hyphen, period (except at end), and Unicode characters that match the allowed characters.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568543 = path.getOrDefault("resourceGroupName")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "resourceGroupName", valid_568543
  var valid_568544 = path.getOrDefault("subscriptionId")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "subscriptionId", valid_568544
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568545 = query.getOrDefault("api-version")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "api-version", valid_568545
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update a resource group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568547: Call_ResourceGroupsCreateOrUpdate_568540; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a resource group.
  ## 
  let valid = call_568547.validator(path, query, header, formData, body)
  let scheme = call_568547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568547.url(scheme.get, call_568547.host, call_568547.base,
                         call_568547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568547, url, valid)

proc call*(call_568548: Call_ResourceGroupsCreateOrUpdate_568540;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## resourceGroupsCreateOrUpdate
  ## Creates or updates a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to create or update. Can include alphanumeric, underscore, parentheses, hyphen, period (except at end), and Unicode characters that match the allowed characters.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update a resource group.
  var path_568549 = newJObject()
  var query_568550 = newJObject()
  var body_568551 = newJObject()
  add(path_568549, "resourceGroupName", newJString(resourceGroupName))
  add(query_568550, "api-version", newJString(apiVersion))
  add(path_568549, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568551 = parameters
  result = call_568548.call(path_568549, query_568550, nil, nil, body_568551)

var resourceGroupsCreateOrUpdate* = Call_ResourceGroupsCreateOrUpdate_568540(
    name: "resourceGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsCreateOrUpdate_568541, base: "",
    url: url_ResourceGroupsCreateOrUpdate_568542, schemes: {Scheme.Https})
type
  Call_ResourceGroupsCheckExistence_568562 = ref object of OpenApiRestCall_567667
proc url_ResourceGroupsCheckExistence_568564(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsCheckExistence_568563(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether a resource group exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568565 = path.getOrDefault("resourceGroupName")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "resourceGroupName", valid_568565
  var valid_568566 = path.getOrDefault("subscriptionId")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "subscriptionId", valid_568566
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568567 = query.getOrDefault("api-version")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "api-version", valid_568567
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568568: Call_ResourceGroupsCheckExistence_568562; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a resource group exists.
  ## 
  let valid = call_568568.validator(path, query, header, formData, body)
  let scheme = call_568568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568568.url(scheme.get, call_568568.host, call_568568.base,
                         call_568568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568568, url, valid)

proc call*(call_568569: Call_ResourceGroupsCheckExistence_568562;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsCheckExistence
  ## Checks whether a resource group exists.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568570 = newJObject()
  var query_568571 = newJObject()
  add(path_568570, "resourceGroupName", newJString(resourceGroupName))
  add(query_568571, "api-version", newJString(apiVersion))
  add(path_568570, "subscriptionId", newJString(subscriptionId))
  result = call_568569.call(path_568570, query_568571, nil, nil, nil)

var resourceGroupsCheckExistence* = Call_ResourceGroupsCheckExistence_568562(
    name: "resourceGroupsCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsCheckExistence_568563, base: "",
    url: url_ResourceGroupsCheckExistence_568564, schemes: {Scheme.Https})
type
  Call_ResourceGroupsGet_568530 = ref object of OpenApiRestCall_567667
proc url_ResourceGroupsGet_568532(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsGet_568531(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568533 = path.getOrDefault("resourceGroupName")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "resourceGroupName", valid_568533
  var valid_568534 = path.getOrDefault("subscriptionId")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "subscriptionId", valid_568534
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568535 = query.getOrDefault("api-version")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "api-version", valid_568535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568536: Call_ResourceGroupsGet_568530; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource group.
  ## 
  let valid = call_568536.validator(path, query, header, formData, body)
  let scheme = call_568536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568536.url(scheme.get, call_568536.host, call_568536.base,
                         call_568536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568536, url, valid)

proc call*(call_568537: Call_ResourceGroupsGet_568530; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsGet
  ## Gets a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568538 = newJObject()
  var query_568539 = newJObject()
  add(path_568538, "resourceGroupName", newJString(resourceGroupName))
  add(query_568539, "api-version", newJString(apiVersion))
  add(path_568538, "subscriptionId", newJString(subscriptionId))
  result = call_568537.call(path_568538, query_568539, nil, nil, nil)

var resourceGroupsGet* = Call_ResourceGroupsGet_568530(name: "resourceGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsGet_568531, base: "",
    url: url_ResourceGroupsGet_568532, schemes: {Scheme.Https})
type
  Call_ResourceGroupsUpdate_568572 = ref object of OpenApiRestCall_567667
proc url_ResourceGroupsUpdate_568574(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsUpdate_568573(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource group. If a field is unspecified, the current value is retained.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to update. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568575 = path.getOrDefault("resourceGroupName")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "resourceGroupName", valid_568575
  var valid_568576 = path.getOrDefault("subscriptionId")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "subscriptionId", valid_568576
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568577 = query.getOrDefault("api-version")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "api-version", valid_568577
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update a resource group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568579: Call_ResourceGroupsUpdate_568572; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource group. If a field is unspecified, the current value is retained.
  ## 
  let valid = call_568579.validator(path, query, header, formData, body)
  let scheme = call_568579.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568579.url(scheme.get, call_568579.host, call_568579.base,
                         call_568579.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568579, url, valid)

proc call*(call_568580: Call_ResourceGroupsUpdate_568572;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## resourceGroupsUpdate
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource group. If a field is unspecified, the current value is retained.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to update. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update a resource group.
  var path_568581 = newJObject()
  var query_568582 = newJObject()
  var body_568583 = newJObject()
  add(path_568581, "resourceGroupName", newJString(resourceGroupName))
  add(query_568582, "api-version", newJString(apiVersion))
  add(path_568581, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568583 = parameters
  result = call_568580.call(path_568581, query_568582, nil, nil, body_568583)

var resourceGroupsUpdate* = Call_ResourceGroupsUpdate_568572(
    name: "resourceGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsUpdate_568573, base: "",
    url: url_ResourceGroupsUpdate_568574, schemes: {Scheme.Https})
type
  Call_ResourceGroupsDelete_568552 = ref object of OpenApiRestCall_567667
proc url_ResourceGroupsDelete_568554(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsDelete_568553(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## When you delete a resource group, all of its resources are also deleted. Deleting a resource group deletes all of its template deployments and currently stored operations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to delete. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568555 = path.getOrDefault("resourceGroupName")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "resourceGroupName", valid_568555
  var valid_568556 = path.getOrDefault("subscriptionId")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "subscriptionId", valid_568556
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568557 = query.getOrDefault("api-version")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "api-version", valid_568557
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568558: Call_ResourceGroupsDelete_568552; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When you delete a resource group, all of its resources are also deleted. Deleting a resource group deletes all of its template deployments and currently stored operations.
  ## 
  let valid = call_568558.validator(path, query, header, formData, body)
  let scheme = call_568558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568558.url(scheme.get, call_568558.host, call_568558.base,
                         call_568558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568558, url, valid)

proc call*(call_568559: Call_ResourceGroupsDelete_568552;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsDelete
  ## When you delete a resource group, all of its resources are also deleted. Deleting a resource group deletes all of its template deployments and currently stored operations.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to delete. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568560 = newJObject()
  var query_568561 = newJObject()
  add(path_568560, "resourceGroupName", newJString(resourceGroupName))
  add(query_568561, "api-version", newJString(apiVersion))
  add(path_568560, "subscriptionId", newJString(subscriptionId))
  result = call_568559.call(path_568560, query_568561, nil, nil, nil)

var resourceGroupsDelete* = Call_ResourceGroupsDelete_568552(
    name: "resourceGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsDelete_568553, base: "",
    url: url_ResourceGroupsDelete_568554, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsList_568584 = ref object of OpenApiRestCall_567667
proc url_DeploymentOperationsList_568586(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsList_568585(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all deployments operations for a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568587 = path.getOrDefault("resourceGroupName")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "resourceGroupName", valid_568587
  var valid_568588 = path.getOrDefault("deploymentName")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "deploymentName", valid_568588
  var valid_568589 = path.getOrDefault("subscriptionId")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "subscriptionId", valid_568589
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568590 = query.getOrDefault("api-version")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "api-version", valid_568590
  var valid_568591 = query.getOrDefault("$top")
  valid_568591 = validateParameter(valid_568591, JInt, required = false, default = nil)
  if valid_568591 != nil:
    section.add "$top", valid_568591
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568592: Call_DeploymentOperationsList_568584; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all deployments operations for a deployment.
  ## 
  let valid = call_568592.validator(path, query, header, formData, body)
  let scheme = call_568592.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568592.url(scheme.get, call_568592.host, call_568592.base,
                         call_568592.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568592, url, valid)

proc call*(call_568593: Call_DeploymentOperationsList_568584;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## deploymentOperationsList
  ## Gets all deployments operations for a deployment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return.
  var path_568594 = newJObject()
  var query_568595 = newJObject()
  add(path_568594, "resourceGroupName", newJString(resourceGroupName))
  add(query_568595, "api-version", newJString(apiVersion))
  add(path_568594, "deploymentName", newJString(deploymentName))
  add(path_568594, "subscriptionId", newJString(subscriptionId))
  add(query_568595, "$top", newJInt(Top))
  result = call_568593.call(path_568594, query_568595, nil, nil, nil)

var deploymentOperationsList* = Call_DeploymentOperationsList_568584(
    name: "deploymentOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/deployments/{deploymentName}/operations",
    validator: validate_DeploymentOperationsList_568585, base: "",
    url: url_DeploymentOperationsList_568586, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsGet_568596 = ref object of OpenApiRestCall_567667
proc url_DeploymentOperationsGet_568598(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsGet_568597(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployments operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   operationId: JString (required)
  ##              : The ID of the operation to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568599 = path.getOrDefault("resourceGroupName")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "resourceGroupName", valid_568599
  var valid_568600 = path.getOrDefault("deploymentName")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "deploymentName", valid_568600
  var valid_568601 = path.getOrDefault("subscriptionId")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "subscriptionId", valid_568601
  var valid_568602 = path.getOrDefault("operationId")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "operationId", valid_568602
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568603 = query.getOrDefault("api-version")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "api-version", valid_568603
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568604: Call_DeploymentOperationsGet_568596; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deployments operation.
  ## 
  let valid = call_568604.validator(path, query, header, formData, body)
  let scheme = call_568604.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568604.url(scheme.get, call_568604.host, call_568604.base,
                         call_568604.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568604, url, valid)

proc call*(call_568605: Call_DeploymentOperationsGet_568596;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string; operationId: string): Recallable =
  ## deploymentOperationsGet
  ## Gets a deployments operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   operationId: string (required)
  ##              : The ID of the operation to get.
  var path_568606 = newJObject()
  var query_568607 = newJObject()
  add(path_568606, "resourceGroupName", newJString(resourceGroupName))
  add(query_568607, "api-version", newJString(apiVersion))
  add(path_568606, "deploymentName", newJString(deploymentName))
  add(path_568606, "subscriptionId", newJString(subscriptionId))
  add(path_568606, "operationId", newJString(operationId))
  result = call_568605.call(path_568606, query_568607, nil, nil, nil)

var deploymentOperationsGet* = Call_DeploymentOperationsGet_568596(
    name: "deploymentOperationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/deployments/{deploymentName}/operations/{operationId}",
    validator: validate_DeploymentOperationsGet_568597, base: "",
    url: url_DeploymentOperationsGet_568598, schemes: {Scheme.Https})
type
  Call_ResourceGroupsExportTemplate_568608 = ref object of OpenApiRestCall_567667
proc url_ResourceGroupsExportTemplate_568610(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/exportTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsExportTemplate_568609(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Captures the specified resource group as a template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to export as a template.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568611 = path.getOrDefault("resourceGroupName")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = nil)
  if valid_568611 != nil:
    section.add "resourceGroupName", valid_568611
  var valid_568612 = path.getOrDefault("subscriptionId")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "subscriptionId", valid_568612
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568613 = query.getOrDefault("api-version")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "api-version", valid_568613
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for exporting the template.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568615: Call_ResourceGroupsExportTemplate_568608; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Captures the specified resource group as a template.
  ## 
  let valid = call_568615.validator(path, query, header, formData, body)
  let scheme = call_568615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568615.url(scheme.get, call_568615.host, call_568615.base,
                         call_568615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568615, url, valid)

proc call*(call_568616: Call_ResourceGroupsExportTemplate_568608;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## resourceGroupsExportTemplate
  ## Captures the specified resource group as a template.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to export as a template.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters for exporting the template.
  var path_568617 = newJObject()
  var query_568618 = newJObject()
  var body_568619 = newJObject()
  add(path_568617, "resourceGroupName", newJString(resourceGroupName))
  add(query_568618, "api-version", newJString(apiVersion))
  add(path_568617, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568619 = parameters
  result = call_568616.call(path_568617, query_568618, nil, nil, body_568619)

var resourceGroupsExportTemplate* = Call_ResourceGroupsExportTemplate_568608(
    name: "resourceGroupsExportTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/exportTemplate",
    validator: validate_ResourceGroupsExportTemplate_568609, base: "",
    url: url_ResourceGroupsExportTemplate_568610, schemes: {Scheme.Https})
type
  Call_DeploymentsListByResourceGroup_568620 = ref object of OpenApiRestCall_567667
proc url_DeploymentsListByResourceGroup_568622(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsListByResourceGroup_568621(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the deployments for a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group with the deployments to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568623 = path.getOrDefault("resourceGroupName")
  valid_568623 = validateParameter(valid_568623, JString, required = true,
                                 default = nil)
  if valid_568623 != nil:
    section.add "resourceGroupName", valid_568623
  var valid_568624 = path.getOrDefault("subscriptionId")
  valid_568624 = validateParameter(valid_568624, JString, required = true,
                                 default = nil)
  if valid_568624 != nil:
    section.add "subscriptionId", valid_568624
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to get. If null is passed, returns all deployments.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568625 = query.getOrDefault("api-version")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "api-version", valid_568625
  var valid_568626 = query.getOrDefault("$top")
  valid_568626 = validateParameter(valid_568626, JInt, required = false, default = nil)
  if valid_568626 != nil:
    section.add "$top", valid_568626
  var valid_568627 = query.getOrDefault("$filter")
  valid_568627 = validateParameter(valid_568627, JString, required = false,
                                 default = nil)
  if valid_568627 != nil:
    section.add "$filter", valid_568627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568628: Call_DeploymentsListByResourceGroup_568620; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the deployments for a resource group.
  ## 
  let valid = call_568628.validator(path, query, header, formData, body)
  let scheme = call_568628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568628.url(scheme.get, call_568628.host, call_568628.base,
                         call_568628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568628, url, valid)

proc call*(call_568629: Call_DeploymentsListByResourceGroup_568620;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## deploymentsListByResourceGroup
  ## Get all the deployments for a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group with the deployments to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to get. If null is passed, returns all deployments.
  ##   Filter: string
  ##         : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  var path_568630 = newJObject()
  var query_568631 = newJObject()
  add(path_568630, "resourceGroupName", newJString(resourceGroupName))
  add(query_568631, "api-version", newJString(apiVersion))
  add(path_568630, "subscriptionId", newJString(subscriptionId))
  add(query_568631, "$top", newJInt(Top))
  add(query_568631, "$filter", newJString(Filter))
  result = call_568629.call(path_568630, query_568631, nil, nil, nil)

var deploymentsListByResourceGroup* = Call_DeploymentsListByResourceGroup_568620(
    name: "deploymentsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/",
    validator: validate_DeploymentsListByResourceGroup_568621, base: "",
    url: url_DeploymentsListByResourceGroup_568622, schemes: {Scheme.Https})
type
  Call_DeploymentsCreateOrUpdate_568643 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCreateOrUpdate_568645(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCreateOrUpdate_568644(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to deploy the resources to. The name is case insensitive. The resource group must already exist.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568646 = path.getOrDefault("resourceGroupName")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "resourceGroupName", valid_568646
  var valid_568647 = path.getOrDefault("deploymentName")
  valid_568647 = validateParameter(valid_568647, JString, required = true,
                                 default = nil)
  if valid_568647 != nil:
    section.add "deploymentName", valid_568647
  var valid_568648 = path.getOrDefault("subscriptionId")
  valid_568648 = validateParameter(valid_568648, JString, required = true,
                                 default = nil)
  if valid_568648 != nil:
    section.add "subscriptionId", valid_568648
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568649 = query.getOrDefault("api-version")
  valid_568649 = validateParameter(valid_568649, JString, required = true,
                                 default = nil)
  if valid_568649 != nil:
    section.add "api-version", valid_568649
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568651: Call_DeploymentsCreateOrUpdate_568643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  let valid = call_568651.validator(path, query, header, formData, body)
  let scheme = call_568651.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568651.url(scheme.get, call_568651.host, call_568651.base,
                         call_568651.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568651, url, valid)

proc call*(call_568652: Call_DeploymentsCreateOrUpdate_568643;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## deploymentsCreateOrUpdate
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to deploy the resources to. The name is case insensitive. The resource group must already exist.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  var path_568653 = newJObject()
  var query_568654 = newJObject()
  var body_568655 = newJObject()
  add(path_568653, "resourceGroupName", newJString(resourceGroupName))
  add(query_568654, "api-version", newJString(apiVersion))
  add(path_568653, "deploymentName", newJString(deploymentName))
  add(path_568653, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568655 = parameters
  result = call_568652.call(path_568653, query_568654, nil, nil, body_568655)

var deploymentsCreateOrUpdate* = Call_DeploymentsCreateOrUpdate_568643(
    name: "deploymentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCreateOrUpdate_568644, base: "",
    url: url_DeploymentsCreateOrUpdate_568645, schemes: {Scheme.Https})
type
  Call_DeploymentsCheckExistence_568667 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCheckExistence_568669(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCheckExistence_568668(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the deployment exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group with the deployment to check. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568670 = path.getOrDefault("resourceGroupName")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "resourceGroupName", valid_568670
  var valid_568671 = path.getOrDefault("deploymentName")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "deploymentName", valid_568671
  var valid_568672 = path.getOrDefault("subscriptionId")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "subscriptionId", valid_568672
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568673 = query.getOrDefault("api-version")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = nil)
  if valid_568673 != nil:
    section.add "api-version", valid_568673
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568674: Call_DeploymentsCheckExistence_568667; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the deployment exists.
  ## 
  let valid = call_568674.validator(path, query, header, formData, body)
  let scheme = call_568674.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568674.url(scheme.get, call_568674.host, call_568674.base,
                         call_568674.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568674, url, valid)

proc call*(call_568675: Call_DeploymentsCheckExistence_568667;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string): Recallable =
  ## deploymentsCheckExistence
  ## Checks whether the deployment exists.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group with the deployment to check. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568676 = newJObject()
  var query_568677 = newJObject()
  add(path_568676, "resourceGroupName", newJString(resourceGroupName))
  add(query_568677, "api-version", newJString(apiVersion))
  add(path_568676, "deploymentName", newJString(deploymentName))
  add(path_568676, "subscriptionId", newJString(subscriptionId))
  result = call_568675.call(path_568676, query_568677, nil, nil, nil)

var deploymentsCheckExistence* = Call_DeploymentsCheckExistence_568667(
    name: "deploymentsCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCheckExistence_568668, base: "",
    url: url_DeploymentsCheckExistence_568669, schemes: {Scheme.Https})
type
  Call_DeploymentsGet_568632 = ref object of OpenApiRestCall_567667
proc url_DeploymentsGet_568634(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsGet_568633(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568635 = path.getOrDefault("resourceGroupName")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = nil)
  if valid_568635 != nil:
    section.add "resourceGroupName", valid_568635
  var valid_568636 = path.getOrDefault("deploymentName")
  valid_568636 = validateParameter(valid_568636, JString, required = true,
                                 default = nil)
  if valid_568636 != nil:
    section.add "deploymentName", valid_568636
  var valid_568637 = path.getOrDefault("subscriptionId")
  valid_568637 = validateParameter(valid_568637, JString, required = true,
                                 default = nil)
  if valid_568637 != nil:
    section.add "subscriptionId", valid_568637
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568638 = query.getOrDefault("api-version")
  valid_568638 = validateParameter(valid_568638, JString, required = true,
                                 default = nil)
  if valid_568638 != nil:
    section.add "api-version", valid_568638
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568639: Call_DeploymentsGet_568632; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deployment.
  ## 
  let valid = call_568639.validator(path, query, header, formData, body)
  let scheme = call_568639.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568639.url(scheme.get, call_568639.host, call_568639.base,
                         call_568639.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568639, url, valid)

proc call*(call_568640: Call_DeploymentsGet_568632; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsGet
  ## Gets a deployment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568641 = newJObject()
  var query_568642 = newJObject()
  add(path_568641, "resourceGroupName", newJString(resourceGroupName))
  add(query_568642, "api-version", newJString(apiVersion))
  add(path_568641, "deploymentName", newJString(deploymentName))
  add(path_568641, "subscriptionId", newJString(subscriptionId))
  result = call_568640.call(path_568641, query_568642, nil, nil, nil)

var deploymentsGet* = Call_DeploymentsGet_568632(name: "deploymentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsGet_568633, base: "", url: url_DeploymentsGet_568634,
    schemes: {Scheme.Https})
type
  Call_DeploymentsDelete_568656 = ref object of OpenApiRestCall_567667
proc url_DeploymentsDelete_568658(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsDelete_568657(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. Deleting a template deployment does not affect the state of the resource group. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group with the deployment to delete. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568659 = path.getOrDefault("resourceGroupName")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "resourceGroupName", valid_568659
  var valid_568660 = path.getOrDefault("deploymentName")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = nil)
  if valid_568660 != nil:
    section.add "deploymentName", valid_568660
  var valid_568661 = path.getOrDefault("subscriptionId")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = nil)
  if valid_568661 != nil:
    section.add "subscriptionId", valid_568661
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568662 = query.getOrDefault("api-version")
  valid_568662 = validateParameter(valid_568662, JString, required = true,
                                 default = nil)
  if valid_568662 != nil:
    section.add "api-version", valid_568662
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568663: Call_DeploymentsDelete_568656; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. Deleting a template deployment does not affect the state of the resource group. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  let valid = call_568663.validator(path, query, header, formData, body)
  let scheme = call_568663.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568663.url(scheme.get, call_568663.host, call_568663.base,
                         call_568663.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568663, url, valid)

proc call*(call_568664: Call_DeploymentsDelete_568656; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsDelete
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. Deleting a template deployment does not affect the state of the resource group. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group with the deployment to delete. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568665 = newJObject()
  var query_568666 = newJObject()
  add(path_568665, "resourceGroupName", newJString(resourceGroupName))
  add(query_568666, "api-version", newJString(apiVersion))
  add(path_568665, "deploymentName", newJString(deploymentName))
  add(path_568665, "subscriptionId", newJString(subscriptionId))
  result = call_568664.call(path_568665, query_568666, nil, nil, nil)

var deploymentsDelete* = Call_DeploymentsDelete_568656(name: "deploymentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsDelete_568657, base: "",
    url: url_DeploymentsDelete_568658, schemes: {Scheme.Https})
type
  Call_DeploymentsCancel_568678 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCancel_568680(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCancel_568679(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resource group partially deployed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568681 = path.getOrDefault("resourceGroupName")
  valid_568681 = validateParameter(valid_568681, JString, required = true,
                                 default = nil)
  if valid_568681 != nil:
    section.add "resourceGroupName", valid_568681
  var valid_568682 = path.getOrDefault("deploymentName")
  valid_568682 = validateParameter(valid_568682, JString, required = true,
                                 default = nil)
  if valid_568682 != nil:
    section.add "deploymentName", valid_568682
  var valid_568683 = path.getOrDefault("subscriptionId")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "subscriptionId", valid_568683
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568684 = query.getOrDefault("api-version")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "api-version", valid_568684
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568685: Call_DeploymentsCancel_568678; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resource group partially deployed.
  ## 
  let valid = call_568685.validator(path, query, header, formData, body)
  let scheme = call_568685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568685.url(scheme.get, call_568685.host, call_568685.base,
                         call_568685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568685, url, valid)

proc call*(call_568686: Call_DeploymentsCancel_568678; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsCancel
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resource group partially deployed.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568687 = newJObject()
  var query_568688 = newJObject()
  add(path_568687, "resourceGroupName", newJString(resourceGroupName))
  add(query_568688, "api-version", newJString(apiVersion))
  add(path_568687, "deploymentName", newJString(deploymentName))
  add(path_568687, "subscriptionId", newJString(subscriptionId))
  result = call_568686.call(path_568687, query_568688, nil, nil, nil)

var deploymentsCancel* = Call_DeploymentsCancel_568678(name: "deploymentsCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/cancel",
    validator: validate_DeploymentsCancel_568679, base: "",
    url: url_DeploymentsCancel_568680, schemes: {Scheme.Https})
type
  Call_DeploymentsExportTemplate_568689 = ref object of OpenApiRestCall_567667
proc url_DeploymentsExportTemplate_568691(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/exportTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsExportTemplate_568690(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports the template used for specified deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568692 = path.getOrDefault("resourceGroupName")
  valid_568692 = validateParameter(valid_568692, JString, required = true,
                                 default = nil)
  if valid_568692 != nil:
    section.add "resourceGroupName", valid_568692
  var valid_568693 = path.getOrDefault("deploymentName")
  valid_568693 = validateParameter(valid_568693, JString, required = true,
                                 default = nil)
  if valid_568693 != nil:
    section.add "deploymentName", valid_568693
  var valid_568694 = path.getOrDefault("subscriptionId")
  valid_568694 = validateParameter(valid_568694, JString, required = true,
                                 default = nil)
  if valid_568694 != nil:
    section.add "subscriptionId", valid_568694
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568695 = query.getOrDefault("api-version")
  valid_568695 = validateParameter(valid_568695, JString, required = true,
                                 default = nil)
  if valid_568695 != nil:
    section.add "api-version", valid_568695
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568696: Call_DeploymentsExportTemplate_568689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the template used for specified deployment.
  ## 
  let valid = call_568696.validator(path, query, header, formData, body)
  let scheme = call_568696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568696.url(scheme.get, call_568696.host, call_568696.base,
                         call_568696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568696, url, valid)

proc call*(call_568697: Call_DeploymentsExportTemplate_568689;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string): Recallable =
  ## deploymentsExportTemplate
  ## Exports the template used for specified deployment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568698 = newJObject()
  var query_568699 = newJObject()
  add(path_568698, "resourceGroupName", newJString(resourceGroupName))
  add(query_568699, "api-version", newJString(apiVersion))
  add(path_568698, "deploymentName", newJString(deploymentName))
  add(path_568698, "subscriptionId", newJString(subscriptionId))
  result = call_568697.call(path_568698, query_568699, nil, nil, nil)

var deploymentsExportTemplate* = Call_DeploymentsExportTemplate_568689(
    name: "deploymentsExportTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/exportTemplate",
    validator: validate_DeploymentsExportTemplate_568690, base: "",
    url: url_DeploymentsExportTemplate_568691, schemes: {Scheme.Https})
type
  Call_DeploymentsValidate_568700 = ref object of OpenApiRestCall_567667
proc url_DeploymentsValidate_568702(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsValidate_568701(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group the template will be deployed to. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568703 = path.getOrDefault("resourceGroupName")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "resourceGroupName", valid_568703
  var valid_568704 = path.getOrDefault("deploymentName")
  valid_568704 = validateParameter(valid_568704, JString, required = true,
                                 default = nil)
  if valid_568704 != nil:
    section.add "deploymentName", valid_568704
  var valid_568705 = path.getOrDefault("subscriptionId")
  valid_568705 = validateParameter(valid_568705, JString, required = true,
                                 default = nil)
  if valid_568705 != nil:
    section.add "subscriptionId", valid_568705
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568706 = query.getOrDefault("api-version")
  valid_568706 = validateParameter(valid_568706, JString, required = true,
                                 default = nil)
  if valid_568706 != nil:
    section.add "api-version", valid_568706
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568708: Call_DeploymentsValidate_568700; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  let valid = call_568708.validator(path, query, header, formData, body)
  let scheme = call_568708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568708.url(scheme.get, call_568708.host, call_568708.base,
                         call_568708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568708, url, valid)

proc call*(call_568709: Call_DeploymentsValidate_568700; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## deploymentsValidate
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group the template will be deployed to. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  var path_568710 = newJObject()
  var query_568711 = newJObject()
  var body_568712 = newJObject()
  add(path_568710, "resourceGroupName", newJString(resourceGroupName))
  add(query_568711, "api-version", newJString(apiVersion))
  add(path_568710, "deploymentName", newJString(deploymentName))
  add(path_568710, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568712 = parameters
  result = call_568709.call(path_568710, query_568711, nil, nil, body_568712)

var deploymentsValidate* = Call_DeploymentsValidate_568700(
    name: "deploymentsValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/validate",
    validator: validate_DeploymentsValidate_568701, base: "",
    url: url_DeploymentsValidate_568702, schemes: {Scheme.Https})
type
  Call_ResourcesCreateOrUpdate_568727 = ref object of OpenApiRestCall_567667
proc url_ResourcesCreateOrUpdate_568729(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCreateOrUpdate_568728(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource to create.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to create.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568730 = path.getOrDefault("resourceType")
  valid_568730 = validateParameter(valid_568730, JString, required = true,
                                 default = nil)
  if valid_568730 != nil:
    section.add "resourceType", valid_568730
  var valid_568731 = path.getOrDefault("resourceGroupName")
  valid_568731 = validateParameter(valid_568731, JString, required = true,
                                 default = nil)
  if valid_568731 != nil:
    section.add "resourceGroupName", valid_568731
  var valid_568732 = path.getOrDefault("subscriptionId")
  valid_568732 = validateParameter(valid_568732, JString, required = true,
                                 default = nil)
  if valid_568732 != nil:
    section.add "subscriptionId", valid_568732
  var valid_568733 = path.getOrDefault("resourceName")
  valid_568733 = validateParameter(valid_568733, JString, required = true,
                                 default = nil)
  if valid_568733 != nil:
    section.add "resourceName", valid_568733
  var valid_568734 = path.getOrDefault("resourceProviderNamespace")
  valid_568734 = validateParameter(valid_568734, JString, required = true,
                                 default = nil)
  if valid_568734 != nil:
    section.add "resourceProviderNamespace", valid_568734
  var valid_568735 = path.getOrDefault("parentResourcePath")
  valid_568735 = validateParameter(valid_568735, JString, required = true,
                                 default = nil)
  if valid_568735 != nil:
    section.add "parentResourcePath", valid_568735
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568736 = query.getOrDefault("api-version")
  valid_568736 = validateParameter(valid_568736, JString, required = true,
                                 default = nil)
  if valid_568736 != nil:
    section.add "api-version", valid_568736
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for creating or updating the resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568738: Call_ResourcesCreateOrUpdate_568727; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a resource.
  ## 
  let valid = call_568738.validator(path, query, header, formData, body)
  let scheme = call_568738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568738.url(scheme.get, call_568738.host, call_568738.base,
                         call_568738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568738, url, valid)

proc call*(call_568739: Call_ResourcesCreateOrUpdate_568727; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode;
          resourceProviderNamespace: string; parentResourcePath: string): Recallable =
  ## resourcesCreateOrUpdate
  ## Creates a resource.
  ##   resourceType: string (required)
  ##               : The resource type of the resource to create.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to create.
  ##   parameters: JObject (required)
  ##             : Parameters for creating or updating the resource.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568740 = newJObject()
  var query_568741 = newJObject()
  var body_568742 = newJObject()
  add(path_568740, "resourceType", newJString(resourceType))
  add(path_568740, "resourceGroupName", newJString(resourceGroupName))
  add(query_568741, "api-version", newJString(apiVersion))
  add(path_568740, "subscriptionId", newJString(subscriptionId))
  add(path_568740, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_568742 = parameters
  add(path_568740, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568740, "parentResourcePath", newJString(parentResourcePath))
  result = call_568739.call(path_568740, query_568741, nil, nil, body_568742)

var resourcesCreateOrUpdate* = Call_ResourcesCreateOrUpdate_568727(
    name: "resourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesCreateOrUpdate_568728, base: "",
    url: url_ResourcesCreateOrUpdate_568729, schemes: {Scheme.Https})
type
  Call_ResourcesCheckExistence_568757 = ref object of OpenApiRestCall_567667
proc url_ResourcesCheckExistence_568759(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCheckExistence_568758(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether a resource exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the resource to check. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to check whether it exists.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The resource provider of the resource to check.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568760 = path.getOrDefault("resourceType")
  valid_568760 = validateParameter(valid_568760, JString, required = true,
                                 default = nil)
  if valid_568760 != nil:
    section.add "resourceType", valid_568760
  var valid_568761 = path.getOrDefault("resourceGroupName")
  valid_568761 = validateParameter(valid_568761, JString, required = true,
                                 default = nil)
  if valid_568761 != nil:
    section.add "resourceGroupName", valid_568761
  var valid_568762 = path.getOrDefault("subscriptionId")
  valid_568762 = validateParameter(valid_568762, JString, required = true,
                                 default = nil)
  if valid_568762 != nil:
    section.add "subscriptionId", valid_568762
  var valid_568763 = path.getOrDefault("resourceName")
  valid_568763 = validateParameter(valid_568763, JString, required = true,
                                 default = nil)
  if valid_568763 != nil:
    section.add "resourceName", valid_568763
  var valid_568764 = path.getOrDefault("resourceProviderNamespace")
  valid_568764 = validateParameter(valid_568764, JString, required = true,
                                 default = nil)
  if valid_568764 != nil:
    section.add "resourceProviderNamespace", valid_568764
  var valid_568765 = path.getOrDefault("parentResourcePath")
  valid_568765 = validateParameter(valid_568765, JString, required = true,
                                 default = nil)
  if valid_568765 != nil:
    section.add "parentResourcePath", valid_568765
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568766 = query.getOrDefault("api-version")
  valid_568766 = validateParameter(valid_568766, JString, required = true,
                                 default = nil)
  if valid_568766 != nil:
    section.add "api-version", valid_568766
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568767: Call_ResourcesCheckExistence_568757; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a resource exists.
  ## 
  let valid = call_568767.validator(path, query, header, formData, body)
  let scheme = call_568767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568767.url(scheme.get, call_568767.host, call_568767.base,
                         call_568767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568767, url, valid)

proc call*(call_568768: Call_ResourcesCheckExistence_568757; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceProviderNamespace: string;
          parentResourcePath: string): Recallable =
  ## resourcesCheckExistence
  ## Checks whether a resource exists.
  ##   resourceType: string (required)
  ##               : The resource type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the resource to check. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to check whether it exists.
  ##   resourceProviderNamespace: string (required)
  ##                            : The resource provider of the resource to check.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568769 = newJObject()
  var query_568770 = newJObject()
  add(path_568769, "resourceType", newJString(resourceType))
  add(path_568769, "resourceGroupName", newJString(resourceGroupName))
  add(query_568770, "api-version", newJString(apiVersion))
  add(path_568769, "subscriptionId", newJString(subscriptionId))
  add(path_568769, "resourceName", newJString(resourceName))
  add(path_568769, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568769, "parentResourcePath", newJString(parentResourcePath))
  result = call_568768.call(path_568769, query_568770, nil, nil, nil)

var resourcesCheckExistence* = Call_ResourcesCheckExistence_568757(
    name: "resourcesCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesCheckExistence_568758, base: "",
    url: url_ResourcesCheckExistence_568759, schemes: {Scheme.Https})
type
  Call_ResourcesGet_568713 = ref object of OpenApiRestCall_567667
proc url_ResourcesGet_568715(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesGet_568714(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the resource to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to get.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568716 = path.getOrDefault("resourceType")
  valid_568716 = validateParameter(valid_568716, JString, required = true,
                                 default = nil)
  if valid_568716 != nil:
    section.add "resourceType", valid_568716
  var valid_568717 = path.getOrDefault("resourceGroupName")
  valid_568717 = validateParameter(valid_568717, JString, required = true,
                                 default = nil)
  if valid_568717 != nil:
    section.add "resourceGroupName", valid_568717
  var valid_568718 = path.getOrDefault("subscriptionId")
  valid_568718 = validateParameter(valid_568718, JString, required = true,
                                 default = nil)
  if valid_568718 != nil:
    section.add "subscriptionId", valid_568718
  var valid_568719 = path.getOrDefault("resourceName")
  valid_568719 = validateParameter(valid_568719, JString, required = true,
                                 default = nil)
  if valid_568719 != nil:
    section.add "resourceName", valid_568719
  var valid_568720 = path.getOrDefault("resourceProviderNamespace")
  valid_568720 = validateParameter(valid_568720, JString, required = true,
                                 default = nil)
  if valid_568720 != nil:
    section.add "resourceProviderNamespace", valid_568720
  var valid_568721 = path.getOrDefault("parentResourcePath")
  valid_568721 = validateParameter(valid_568721, JString, required = true,
                                 default = nil)
  if valid_568721 != nil:
    section.add "parentResourcePath", valid_568721
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568722 = query.getOrDefault("api-version")
  valid_568722 = validateParameter(valid_568722, JString, required = true,
                                 default = nil)
  if valid_568722 != nil:
    section.add "api-version", valid_568722
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568723: Call_ResourcesGet_568713; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource.
  ## 
  let valid = call_568723.validator(path, query, header, formData, body)
  let scheme = call_568723.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568723.url(scheme.get, call_568723.host, call_568723.base,
                         call_568723.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568723, url, valid)

proc call*(call_568724: Call_ResourcesGet_568713; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceProviderNamespace: string;
          parentResourcePath: string): Recallable =
  ## resourcesGet
  ## Gets a resource.
  ##   resourceType: string (required)
  ##               : The resource type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the resource to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to get.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568725 = newJObject()
  var query_568726 = newJObject()
  add(path_568725, "resourceType", newJString(resourceType))
  add(path_568725, "resourceGroupName", newJString(resourceGroupName))
  add(query_568726, "api-version", newJString(apiVersion))
  add(path_568725, "subscriptionId", newJString(subscriptionId))
  add(path_568725, "resourceName", newJString(resourceName))
  add(path_568725, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568725, "parentResourcePath", newJString(parentResourcePath))
  result = call_568724.call(path_568725, query_568726, nil, nil, nil)

var resourcesGet* = Call_ResourcesGet_568713(name: "resourcesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesGet_568714, base: "", url: url_ResourcesGet_568715,
    schemes: {Scheme.Https})
type
  Call_ResourcesUpdate_568771 = ref object of OpenApiRestCall_567667
proc url_ResourcesUpdate_568773(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesUpdate_568772(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource to update.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to update.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568774 = path.getOrDefault("resourceType")
  valid_568774 = validateParameter(valid_568774, JString, required = true,
                                 default = nil)
  if valid_568774 != nil:
    section.add "resourceType", valid_568774
  var valid_568775 = path.getOrDefault("resourceGroupName")
  valid_568775 = validateParameter(valid_568775, JString, required = true,
                                 default = nil)
  if valid_568775 != nil:
    section.add "resourceGroupName", valid_568775
  var valid_568776 = path.getOrDefault("subscriptionId")
  valid_568776 = validateParameter(valid_568776, JString, required = true,
                                 default = nil)
  if valid_568776 != nil:
    section.add "subscriptionId", valid_568776
  var valid_568777 = path.getOrDefault("resourceName")
  valid_568777 = validateParameter(valid_568777, JString, required = true,
                                 default = nil)
  if valid_568777 != nil:
    section.add "resourceName", valid_568777
  var valid_568778 = path.getOrDefault("resourceProviderNamespace")
  valid_568778 = validateParameter(valid_568778, JString, required = true,
                                 default = nil)
  if valid_568778 != nil:
    section.add "resourceProviderNamespace", valid_568778
  var valid_568779 = path.getOrDefault("parentResourcePath")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "parentResourcePath", valid_568779
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568780 = query.getOrDefault("api-version")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "api-version", valid_568780
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for updating the resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568782: Call_ResourcesUpdate_568771; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource.
  ## 
  let valid = call_568782.validator(path, query, header, formData, body)
  let scheme = call_568782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568782.url(scheme.get, call_568782.host, call_568782.base,
                         call_568782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568782, url, valid)

proc call*(call_568783: Call_ResourcesUpdate_568771; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode;
          resourceProviderNamespace: string; parentResourcePath: string): Recallable =
  ## resourcesUpdate
  ## Updates a resource.
  ##   resourceType: string (required)
  ##               : The resource type of the resource to update.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to update.
  ##   parameters: JObject (required)
  ##             : Parameters for updating the resource.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568784 = newJObject()
  var query_568785 = newJObject()
  var body_568786 = newJObject()
  add(path_568784, "resourceType", newJString(resourceType))
  add(path_568784, "resourceGroupName", newJString(resourceGroupName))
  add(query_568785, "api-version", newJString(apiVersion))
  add(path_568784, "subscriptionId", newJString(subscriptionId))
  add(path_568784, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_568786 = parameters
  add(path_568784, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568784, "parentResourcePath", newJString(parentResourcePath))
  result = call_568783.call(path_568784, query_568785, nil, nil, body_568786)

var resourcesUpdate* = Call_ResourcesUpdate_568771(name: "resourcesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesUpdate_568772, base: "", url: url_ResourcesUpdate_568773,
    schemes: {Scheme.Https})
type
  Call_ResourcesDelete_568743 = ref object of OpenApiRestCall_567667
proc url_ResourcesDelete_568745(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesDelete_568744(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource to delete. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to delete.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568746 = path.getOrDefault("resourceType")
  valid_568746 = validateParameter(valid_568746, JString, required = true,
                                 default = nil)
  if valid_568746 != nil:
    section.add "resourceType", valid_568746
  var valid_568747 = path.getOrDefault("resourceGroupName")
  valid_568747 = validateParameter(valid_568747, JString, required = true,
                                 default = nil)
  if valid_568747 != nil:
    section.add "resourceGroupName", valid_568747
  var valid_568748 = path.getOrDefault("subscriptionId")
  valid_568748 = validateParameter(valid_568748, JString, required = true,
                                 default = nil)
  if valid_568748 != nil:
    section.add "subscriptionId", valid_568748
  var valid_568749 = path.getOrDefault("resourceName")
  valid_568749 = validateParameter(valid_568749, JString, required = true,
                                 default = nil)
  if valid_568749 != nil:
    section.add "resourceName", valid_568749
  var valid_568750 = path.getOrDefault("resourceProviderNamespace")
  valid_568750 = validateParameter(valid_568750, JString, required = true,
                                 default = nil)
  if valid_568750 != nil:
    section.add "resourceProviderNamespace", valid_568750
  var valid_568751 = path.getOrDefault("parentResourcePath")
  valid_568751 = validateParameter(valid_568751, JString, required = true,
                                 default = nil)
  if valid_568751 != nil:
    section.add "parentResourcePath", valid_568751
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568752 = query.getOrDefault("api-version")
  valid_568752 = validateParameter(valid_568752, JString, required = true,
                                 default = nil)
  if valid_568752 != nil:
    section.add "api-version", valid_568752
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568753: Call_ResourcesDelete_568743; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a resource.
  ## 
  let valid = call_568753.validator(path, query, header, formData, body)
  let scheme = call_568753.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568753.url(scheme.get, call_568753.host, call_568753.base,
                         call_568753.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568753, url, valid)

proc call*(call_568754: Call_ResourcesDelete_568743; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceProviderNamespace: string;
          parentResourcePath: string): Recallable =
  ## resourcesDelete
  ## Deletes a resource.
  ##   resourceType: string (required)
  ##               : The resource type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource to delete. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to delete.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568755 = newJObject()
  var query_568756 = newJObject()
  add(path_568755, "resourceType", newJString(resourceType))
  add(path_568755, "resourceGroupName", newJString(resourceGroupName))
  add(query_568756, "api-version", newJString(apiVersion))
  add(path_568755, "subscriptionId", newJString(subscriptionId))
  add(path_568755, "resourceName", newJString(resourceName))
  add(path_568755, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568755, "parentResourcePath", newJString(parentResourcePath))
  result = call_568754.call(path_568755, query_568756, nil, nil, nil)

var resourcesDelete* = Call_ResourcesDelete_568743(name: "resourcesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesDelete_568744, base: "", url: url_ResourcesDelete_568745,
    schemes: {Scheme.Https})
type
  Call_ResourcesList_568787 = ref object of OpenApiRestCall_567667
proc url_ResourcesList_568789(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesList_568788(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the resources in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568790 = path.getOrDefault("subscriptionId")
  valid_568790 = validateParameter(valid_568790, JString, required = true,
                                 default = nil)
  if valid_568790 != nil:
    section.add "subscriptionId", valid_568790
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand query parameter. You can expand createdTime and changedTime. For example, to expand both properties, use $expand=changedTime,createdTime
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed, returns all resource groups.
  ##   $filter: JString
  ##          : The filter to apply on the operation.<br><br>The properties you can use for eq (equals) or ne (not equals) are: location, resourceType, name, resourceGroup, identity, identity/principalId, plan, plan/publisher, plan/product, plan/name, plan/version, and plan/promotionCode.<br><br>For example, to filter by a resource type, use: $filter=resourceType eq 'Microsoft.Network/virtualNetworks'<br><br>You can use substringof(value, property) in the filter. The properties you can use for substring are: name and resourceGroup.<br><br>For example, to get all resources with 'demo' anywhere in the name, use: $filter=substringof('demo', name)<br><br>You can link more than one substringof together by adding and/or operators.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'<br><br>You can use some properties together when filtering. The combinations you can use are: substringof and/or resourceType, plan and plan/publisher and plan/name, identity and identity/principalId.
  section = newJObject()
  var valid_568791 = query.getOrDefault("$expand")
  valid_568791 = validateParameter(valid_568791, JString, required = false,
                                 default = nil)
  if valid_568791 != nil:
    section.add "$expand", valid_568791
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568792 = query.getOrDefault("api-version")
  valid_568792 = validateParameter(valid_568792, JString, required = true,
                                 default = nil)
  if valid_568792 != nil:
    section.add "api-version", valid_568792
  var valid_568793 = query.getOrDefault("$top")
  valid_568793 = validateParameter(valid_568793, JInt, required = false, default = nil)
  if valid_568793 != nil:
    section.add "$top", valid_568793
  var valid_568794 = query.getOrDefault("$filter")
  valid_568794 = validateParameter(valid_568794, JString, required = false,
                                 default = nil)
  if valid_568794 != nil:
    section.add "$filter", valid_568794
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568795: Call_ResourcesList_568787; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the resources in a subscription.
  ## 
  let valid = call_568795.validator(path, query, header, formData, body)
  let scheme = call_568795.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568795.url(scheme.get, call_568795.host, call_568795.base,
                         call_568795.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568795, url, valid)

proc call*(call_568796: Call_ResourcesList_568787; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## resourcesList
  ## Get all the resources in a subscription.
  ##   Expand: string
  ##         : The $expand query parameter. You can expand createdTime and changedTime. For example, to expand both properties, use $expand=changedTime,createdTime
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return. If null is passed, returns all resource groups.
  ##   Filter: string
  ##         : The filter to apply on the operation.<br><br>The properties you can use for eq (equals) or ne (not equals) are: location, resourceType, name, resourceGroup, identity, identity/principalId, plan, plan/publisher, plan/product, plan/name, plan/version, and plan/promotionCode.<br><br>For example, to filter by a resource type, use: $filter=resourceType eq 'Microsoft.Network/virtualNetworks'<br><br>You can use substringof(value, property) in the filter. The properties you can use for substring are: name and resourceGroup.<br><br>For example, to get all resources with 'demo' anywhere in the name, use: $filter=substringof('demo', name)<br><br>You can link more than one substringof together by adding and/or operators.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'<br><br>You can use some properties together when filtering. The combinations you can use are: substringof and/or resourceType, plan and plan/publisher and plan/name, identity and identity/principalId.
  var path_568797 = newJObject()
  var query_568798 = newJObject()
  add(query_568798, "$expand", newJString(Expand))
  add(query_568798, "api-version", newJString(apiVersion))
  add(path_568797, "subscriptionId", newJString(subscriptionId))
  add(query_568798, "$top", newJInt(Top))
  add(query_568798, "$filter", newJString(Filter))
  result = call_568796.call(path_568797, query_568798, nil, nil, nil)

var resourcesList* = Call_ResourcesList_568787(name: "resourcesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/resources",
    validator: validate_ResourcesList_568788, base: "", url: url_ResourcesList_568789,
    schemes: {Scheme.Https})
type
  Call_TagsList_568799 = ref object of OpenApiRestCall_567667
proc url_TagsList_568801(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsList_568800(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the names and values of all resource tags that are defined in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568802 = path.getOrDefault("subscriptionId")
  valid_568802 = validateParameter(valid_568802, JString, required = true,
                                 default = nil)
  if valid_568802 != nil:
    section.add "subscriptionId", valid_568802
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568803 = query.getOrDefault("api-version")
  valid_568803 = validateParameter(valid_568803, JString, required = true,
                                 default = nil)
  if valid_568803 != nil:
    section.add "api-version", valid_568803
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568804: Call_TagsList_568799; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the names and values of all resource tags that are defined in a subscription.
  ## 
  let valid = call_568804.validator(path, query, header, formData, body)
  let scheme = call_568804.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568804.url(scheme.get, call_568804.host, call_568804.base,
                         call_568804.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568804, url, valid)

proc call*(call_568805: Call_TagsList_568799; apiVersion: string;
          subscriptionId: string): Recallable =
  ## tagsList
  ## Gets the names and values of all resource tags that are defined in a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568806 = newJObject()
  var query_568807 = newJObject()
  add(query_568807, "api-version", newJString(apiVersion))
  add(path_568806, "subscriptionId", newJString(subscriptionId))
  result = call_568805.call(path_568806, query_568807, nil, nil, nil)

var tagsList* = Call_TagsList_568799(name: "tagsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames",
                                  validator: validate_TagsList_568800, base: "",
                                  url: url_TagsList_568801,
                                  schemes: {Scheme.Https})
type
  Call_TagsCreateOrUpdate_568808 = ref object of OpenApiRestCall_567667
proc url_TagsCreateOrUpdate_568810(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsCreateOrUpdate_568809(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The tag name can have a maximum of 512 characters and is case insensitive. Tag names created by Azure have prefixes of microsoft, azure, or windows. You cannot create tags with one of these prefixes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag to create.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_568811 = path.getOrDefault("tagName")
  valid_568811 = validateParameter(valid_568811, JString, required = true,
                                 default = nil)
  if valid_568811 != nil:
    section.add "tagName", valid_568811
  var valid_568812 = path.getOrDefault("subscriptionId")
  valid_568812 = validateParameter(valid_568812, JString, required = true,
                                 default = nil)
  if valid_568812 != nil:
    section.add "subscriptionId", valid_568812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568813 = query.getOrDefault("api-version")
  valid_568813 = validateParameter(valid_568813, JString, required = true,
                                 default = nil)
  if valid_568813 != nil:
    section.add "api-version", valid_568813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568814: Call_TagsCreateOrUpdate_568808; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tag name can have a maximum of 512 characters and is case insensitive. Tag names created by Azure have prefixes of microsoft, azure, or windows. You cannot create tags with one of these prefixes.
  ## 
  let valid = call_568814.validator(path, query, header, formData, body)
  let scheme = call_568814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568814.url(scheme.get, call_568814.host, call_568814.base,
                         call_568814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568814, url, valid)

proc call*(call_568815: Call_TagsCreateOrUpdate_568808; apiVersion: string;
          tagName: string; subscriptionId: string): Recallable =
  ## tagsCreateOrUpdate
  ## The tag name can have a maximum of 512 characters and is case insensitive. Tag names created by Azure have prefixes of microsoft, azure, or windows. You cannot create tags with one of these prefixes.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag to create.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568816 = newJObject()
  var query_568817 = newJObject()
  add(query_568817, "api-version", newJString(apiVersion))
  add(path_568816, "tagName", newJString(tagName))
  add(path_568816, "subscriptionId", newJString(subscriptionId))
  result = call_568815.call(path_568816, query_568817, nil, nil, nil)

var tagsCreateOrUpdate* = Call_TagsCreateOrUpdate_568808(
    name: "tagsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/tagNames/{tagName}",
    validator: validate_TagsCreateOrUpdate_568809, base: "",
    url: url_TagsCreateOrUpdate_568810, schemes: {Scheme.Https})
type
  Call_TagsDelete_568818 = ref object of OpenApiRestCall_567667
proc url_TagsDelete_568820(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsDelete_568819(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## You must remove all values from a resource tag before you can delete it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_568821 = path.getOrDefault("tagName")
  valid_568821 = validateParameter(valid_568821, JString, required = true,
                                 default = nil)
  if valid_568821 != nil:
    section.add "tagName", valid_568821
  var valid_568822 = path.getOrDefault("subscriptionId")
  valid_568822 = validateParameter(valid_568822, JString, required = true,
                                 default = nil)
  if valid_568822 != nil:
    section.add "subscriptionId", valid_568822
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568823 = query.getOrDefault("api-version")
  valid_568823 = validateParameter(valid_568823, JString, required = true,
                                 default = nil)
  if valid_568823 != nil:
    section.add "api-version", valid_568823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568824: Call_TagsDelete_568818; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You must remove all values from a resource tag before you can delete it.
  ## 
  let valid = call_568824.validator(path, query, header, formData, body)
  let scheme = call_568824.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568824.url(scheme.get, call_568824.host, call_568824.base,
                         call_568824.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568824, url, valid)

proc call*(call_568825: Call_TagsDelete_568818; apiVersion: string; tagName: string;
          subscriptionId: string): Recallable =
  ## tagsDelete
  ## You must remove all values from a resource tag before you can delete it.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568826 = newJObject()
  var query_568827 = newJObject()
  add(query_568827, "api-version", newJString(apiVersion))
  add(path_568826, "tagName", newJString(tagName))
  add(path_568826, "subscriptionId", newJString(subscriptionId))
  result = call_568825.call(path_568826, query_568827, nil, nil, nil)

var tagsDelete* = Call_TagsDelete_568818(name: "tagsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}",
                                      validator: validate_TagsDelete_568819,
                                      base: "", url: url_TagsDelete_568820,
                                      schemes: {Scheme.Https})
type
  Call_TagsCreateOrUpdateValue_568828 = ref object of OpenApiRestCall_567667
proc url_TagsCreateOrUpdateValue_568830(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  assert "tagValue" in path, "`tagValue` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName"),
               (kind: ConstantSegment, value: "/tagValues/"),
               (kind: VariableSegment, value: "tagValue")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsCreateOrUpdateValue_568829(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a tag value. The name of the tag must already exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   tagValue: JString (required)
  ##           : The value of the tag to create.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_568831 = path.getOrDefault("tagName")
  valid_568831 = validateParameter(valid_568831, JString, required = true,
                                 default = nil)
  if valid_568831 != nil:
    section.add "tagName", valid_568831
  var valid_568832 = path.getOrDefault("subscriptionId")
  valid_568832 = validateParameter(valid_568832, JString, required = true,
                                 default = nil)
  if valid_568832 != nil:
    section.add "subscriptionId", valid_568832
  var valid_568833 = path.getOrDefault("tagValue")
  valid_568833 = validateParameter(valid_568833, JString, required = true,
                                 default = nil)
  if valid_568833 != nil:
    section.add "tagValue", valid_568833
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568834 = query.getOrDefault("api-version")
  valid_568834 = validateParameter(valid_568834, JString, required = true,
                                 default = nil)
  if valid_568834 != nil:
    section.add "api-version", valid_568834
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568835: Call_TagsCreateOrUpdateValue_568828; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a tag value. The name of the tag must already exist.
  ## 
  let valid = call_568835.validator(path, query, header, formData, body)
  let scheme = call_568835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568835.url(scheme.get, call_568835.host, call_568835.base,
                         call_568835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568835, url, valid)

proc call*(call_568836: Call_TagsCreateOrUpdateValue_568828; apiVersion: string;
          tagName: string; subscriptionId: string; tagValue: string): Recallable =
  ## tagsCreateOrUpdateValue
  ## Creates a tag value. The name of the tag must already exist.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   tagValue: string (required)
  ##           : The value of the tag to create.
  var path_568837 = newJObject()
  var query_568838 = newJObject()
  add(query_568838, "api-version", newJString(apiVersion))
  add(path_568837, "tagName", newJString(tagName))
  add(path_568837, "subscriptionId", newJString(subscriptionId))
  add(path_568837, "tagValue", newJString(tagValue))
  result = call_568836.call(path_568837, query_568838, nil, nil, nil)

var tagsCreateOrUpdateValue* = Call_TagsCreateOrUpdateValue_568828(
    name: "tagsCreateOrUpdateValue", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}/tagValues/{tagValue}",
    validator: validate_TagsCreateOrUpdateValue_568829, base: "",
    url: url_TagsCreateOrUpdateValue_568830, schemes: {Scheme.Https})
type
  Call_TagsDeleteValue_568839 = ref object of OpenApiRestCall_567667
proc url_TagsDeleteValue_568841(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  assert "tagValue" in path, "`tagValue` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName"),
               (kind: ConstantSegment, value: "/tagValues/"),
               (kind: VariableSegment, value: "tagValue")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsDeleteValue_568840(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a tag value.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   tagValue: JString (required)
  ##           : The value of the tag to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_568842 = path.getOrDefault("tagName")
  valid_568842 = validateParameter(valid_568842, JString, required = true,
                                 default = nil)
  if valid_568842 != nil:
    section.add "tagName", valid_568842
  var valid_568843 = path.getOrDefault("subscriptionId")
  valid_568843 = validateParameter(valid_568843, JString, required = true,
                                 default = nil)
  if valid_568843 != nil:
    section.add "subscriptionId", valid_568843
  var valid_568844 = path.getOrDefault("tagValue")
  valid_568844 = validateParameter(valid_568844, JString, required = true,
                                 default = nil)
  if valid_568844 != nil:
    section.add "tagValue", valid_568844
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568845 = query.getOrDefault("api-version")
  valid_568845 = validateParameter(valid_568845, JString, required = true,
                                 default = nil)
  if valid_568845 != nil:
    section.add "api-version", valid_568845
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568846: Call_TagsDeleteValue_568839; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a tag value.
  ## 
  let valid = call_568846.validator(path, query, header, formData, body)
  let scheme = call_568846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568846.url(scheme.get, call_568846.host, call_568846.base,
                         call_568846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568846, url, valid)

proc call*(call_568847: Call_TagsDeleteValue_568839; apiVersion: string;
          tagName: string; subscriptionId: string; tagValue: string): Recallable =
  ## tagsDeleteValue
  ## Deletes a tag value.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   tagValue: string (required)
  ##           : The value of the tag to delete.
  var path_568848 = newJObject()
  var query_568849 = newJObject()
  add(query_568849, "api-version", newJString(apiVersion))
  add(path_568848, "tagName", newJString(tagName))
  add(path_568848, "subscriptionId", newJString(subscriptionId))
  add(path_568848, "tagValue", newJString(tagValue))
  result = call_568847.call(path_568848, query_568849, nil, nil, nil)

var tagsDeleteValue* = Call_TagsDeleteValue_568839(name: "tagsDeleteValue",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}/tagValues/{tagValue}",
    validator: validate_TagsDeleteValue_568840, base: "", url: url_TagsDeleteValue_568841,
    schemes: {Scheme.Https})
type
  Call_ResourcesCreateOrUpdateById_568859 = ref object of OpenApiRestCall_567667
proc url_ResourcesCreateOrUpdateById_568861(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCreateOrUpdateById_568860(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a resource by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568862 = path.getOrDefault("resourceId")
  valid_568862 = validateParameter(valid_568862, JString, required = true,
                                 default = nil)
  if valid_568862 != nil:
    section.add "resourceId", valid_568862
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568863 = query.getOrDefault("api-version")
  valid_568863 = validateParameter(valid_568863, JString, required = true,
                                 default = nil)
  if valid_568863 != nil:
    section.add "api-version", valid_568863
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create or update resource parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568865: Call_ResourcesCreateOrUpdateById_568859; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource by ID.
  ## 
  let valid = call_568865.validator(path, query, header, formData, body)
  let scheme = call_568865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568865.url(scheme.get, call_568865.host, call_568865.base,
                         call_568865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568865, url, valid)

proc call*(call_568866: Call_ResourcesCreateOrUpdateById_568859;
          apiVersion: string; resourceId: string; parameters: JsonNode): Recallable =
  ## resourcesCreateOrUpdateById
  ## Create a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  ##   parameters: JObject (required)
  ##             : Create or update resource parameters.
  var path_568867 = newJObject()
  var query_568868 = newJObject()
  var body_568869 = newJObject()
  add(query_568868, "api-version", newJString(apiVersion))
  add(path_568867, "resourceId", newJString(resourceId))
  if parameters != nil:
    body_568869 = parameters
  result = call_568866.call(path_568867, query_568868, nil, nil, body_568869)

var resourcesCreateOrUpdateById* = Call_ResourcesCreateOrUpdateById_568859(
    name: "resourcesCreateOrUpdateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesCreateOrUpdateById_568860, base: "",
    url: url_ResourcesCreateOrUpdateById_568861, schemes: {Scheme.Https})
type
  Call_ResourcesCheckExistenceById_568879 = ref object of OpenApiRestCall_567667
proc url_ResourcesCheckExistenceById_568881(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCheckExistenceById_568880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks by ID whether a resource exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568882 = path.getOrDefault("resourceId")
  valid_568882 = validateParameter(valid_568882, JString, required = true,
                                 default = nil)
  if valid_568882 != nil:
    section.add "resourceId", valid_568882
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568883 = query.getOrDefault("api-version")
  valid_568883 = validateParameter(valid_568883, JString, required = true,
                                 default = nil)
  if valid_568883 != nil:
    section.add "api-version", valid_568883
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568884: Call_ResourcesCheckExistenceById_568879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks by ID whether a resource exists.
  ## 
  let valid = call_568884.validator(path, query, header, formData, body)
  let scheme = call_568884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568884.url(scheme.get, call_568884.host, call_568884.base,
                         call_568884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568884, url, valid)

proc call*(call_568885: Call_ResourcesCheckExistenceById_568879;
          apiVersion: string; resourceId: string): Recallable =
  ## resourcesCheckExistenceById
  ## Checks by ID whether a resource exists.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  var path_568886 = newJObject()
  var query_568887 = newJObject()
  add(query_568887, "api-version", newJString(apiVersion))
  add(path_568886, "resourceId", newJString(resourceId))
  result = call_568885.call(path_568886, query_568887, nil, nil, nil)

var resourcesCheckExistenceById* = Call_ResourcesCheckExistenceById_568879(
    name: "resourcesCheckExistenceById", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesCheckExistenceById_568880, base: "",
    url: url_ResourcesCheckExistenceById_568881, schemes: {Scheme.Https})
type
  Call_ResourcesGetById_568850 = ref object of OpenApiRestCall_567667
proc url_ResourcesGetById_568852(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesGetById_568851(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a resource by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568853 = path.getOrDefault("resourceId")
  valid_568853 = validateParameter(valid_568853, JString, required = true,
                                 default = nil)
  if valid_568853 != nil:
    section.add "resourceId", valid_568853
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568854 = query.getOrDefault("api-version")
  valid_568854 = validateParameter(valid_568854, JString, required = true,
                                 default = nil)
  if valid_568854 != nil:
    section.add "api-version", valid_568854
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568855: Call_ResourcesGetById_568850; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource by ID.
  ## 
  let valid = call_568855.validator(path, query, header, formData, body)
  let scheme = call_568855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568855.url(scheme.get, call_568855.host, call_568855.base,
                         call_568855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568855, url, valid)

proc call*(call_568856: Call_ResourcesGetById_568850; apiVersion: string;
          resourceId: string): Recallable =
  ## resourcesGetById
  ## Gets a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  var path_568857 = newJObject()
  var query_568858 = newJObject()
  add(query_568858, "api-version", newJString(apiVersion))
  add(path_568857, "resourceId", newJString(resourceId))
  result = call_568856.call(path_568857, query_568858, nil, nil, nil)

var resourcesGetById* = Call_ResourcesGetById_568850(name: "resourcesGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesGetById_568851, base: "",
    url: url_ResourcesGetById_568852, schemes: {Scheme.Https})
type
  Call_ResourcesUpdateById_568888 = ref object of OpenApiRestCall_567667
proc url_ResourcesUpdateById_568890(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesUpdateById_568889(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a resource by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568891 = path.getOrDefault("resourceId")
  valid_568891 = validateParameter(valid_568891, JString, required = true,
                                 default = nil)
  if valid_568891 != nil:
    section.add "resourceId", valid_568891
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568892 = query.getOrDefault("api-version")
  valid_568892 = validateParameter(valid_568892, JString, required = true,
                                 default = nil)
  if valid_568892 != nil:
    section.add "api-version", valid_568892
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update resource parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568894: Call_ResourcesUpdateById_568888; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource by ID.
  ## 
  let valid = call_568894.validator(path, query, header, formData, body)
  let scheme = call_568894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568894.url(scheme.get, call_568894.host, call_568894.base,
                         call_568894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568894, url, valid)

proc call*(call_568895: Call_ResourcesUpdateById_568888; apiVersion: string;
          resourceId: string; parameters: JsonNode): Recallable =
  ## resourcesUpdateById
  ## Updates a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  ##   parameters: JObject (required)
  ##             : Update resource parameters.
  var path_568896 = newJObject()
  var query_568897 = newJObject()
  var body_568898 = newJObject()
  add(query_568897, "api-version", newJString(apiVersion))
  add(path_568896, "resourceId", newJString(resourceId))
  if parameters != nil:
    body_568898 = parameters
  result = call_568895.call(path_568896, query_568897, nil, nil, body_568898)

var resourcesUpdateById* = Call_ResourcesUpdateById_568888(
    name: "resourcesUpdateById", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesUpdateById_568889, base: "",
    url: url_ResourcesUpdateById_568890, schemes: {Scheme.Https})
type
  Call_ResourcesDeleteById_568870 = ref object of OpenApiRestCall_567667
proc url_ResourcesDeleteById_568872(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesDeleteById_568871(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a resource by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568873 = path.getOrDefault("resourceId")
  valid_568873 = validateParameter(valid_568873, JString, required = true,
                                 default = nil)
  if valid_568873 != nil:
    section.add "resourceId", valid_568873
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568874 = query.getOrDefault("api-version")
  valid_568874 = validateParameter(valid_568874, JString, required = true,
                                 default = nil)
  if valid_568874 != nil:
    section.add "api-version", valid_568874
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568875: Call_ResourcesDeleteById_568870; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a resource by ID.
  ## 
  let valid = call_568875.validator(path, query, header, formData, body)
  let scheme = call_568875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568875.url(scheme.get, call_568875.host, call_568875.base,
                         call_568875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568875, url, valid)

proc call*(call_568876: Call_ResourcesDeleteById_568870; apiVersion: string;
          resourceId: string): Recallable =
  ## resourcesDeleteById
  ## Deletes a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  var path_568877 = newJObject()
  var query_568878 = newJObject()
  add(query_568878, "api-version", newJString(apiVersion))
  add(path_568877, "resourceId", newJString(resourceId))
  result = call_568876.call(path_568877, query_568878, nil, nil, nil)

var resourcesDeleteById* = Call_ResourcesDeleteById_568870(
    name: "resourcesDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesDeleteById_568871, base: "",
    url: url_ResourcesDeleteById_568872, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
