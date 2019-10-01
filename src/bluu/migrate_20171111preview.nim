
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Migrate
## version: 2017-11-11-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Move your workloads to Azure.
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
  macServiceName = "migrate"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567881 = ref object of OpenApiRestCall_567659
proc url_OperationsList_567883(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567882(path: JsonNode; query: JsonNode;
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

proc call*(call_567988: Call_OperationsList_567881; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  ## 
  let valid = call_567988.validator(path, query, header, formData, body)
  let scheme = call_567988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_567988.url(scheme.get, call_567988.host, call_567988.base,
                         call_567988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_567988, url, valid)

proc call*(call_568072: Call_OperationsList_567881): Recallable =
  ## operationsList
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  result = call_568072.call(nil, nil, nil, nil, nil)

var operationsList* = Call_OperationsList_567881(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Migrate/operations",
    validator: validate_OperationsList_567882, base: "", url: url_OperationsList_567883,
    schemes: {Scheme.Https})
type
  Call_AssessmentsListByProject_568110 = ref object of OpenApiRestCall_567659
proc url_AssessmentsListByProject_568112(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/assessments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsListByProject_568111(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all assessments created in the project.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568190 = path.getOrDefault("resourceGroupName")
  valid_568190 = validateParameter(valid_568190, JString, required = true,
                                 default = nil)
  if valid_568190 != nil:
    section.add "resourceGroupName", valid_568190
  var valid_568191 = path.getOrDefault("subscriptionId")
  valid_568191 = validateParameter(valid_568191, JString, required = true,
                                 default = nil)
  if valid_568191 != nil:
    section.add "subscriptionId", valid_568191
  var valid_568192 = path.getOrDefault("projectName")
  valid_568192 = validateParameter(valid_568192, JString, required = true,
                                 default = nil)
  if valid_568192 != nil:
    section.add "projectName", valid_568192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568206 != nil:
    section.add "api-version", valid_568206
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568207 = header.getOrDefault("Accept-Language")
  valid_568207 = validateParameter(valid_568207, JString, required = false,
                                 default = nil)
  if valid_568207 != nil:
    section.add "Accept-Language", valid_568207
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568208: Call_AssessmentsListByProject_568110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all assessments created in the project.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_AssessmentsListByProject_568110;
          resourceGroupName: string; subscriptionId: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## assessmentsListByProject
  ## Get all assessments created in the project.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568210 = newJObject()
  var query_568212 = newJObject()
  add(path_568210, "resourceGroupName", newJString(resourceGroupName))
  add(query_568212, "api-version", newJString(apiVersion))
  add(path_568210, "subscriptionId", newJString(subscriptionId))
  add(path_568210, "projectName", newJString(projectName))
  result = call_568209.call(path_568210, query_568212, nil, nil, nil)

var assessmentsListByProject* = Call_AssessmentsListByProject_568110(
    name: "assessmentsListByProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/assessments",
    validator: validate_AssessmentsListByProject_568111, base: "",
    url: url_AssessmentsListByProject_568112, schemes: {Scheme.Https})
type
  Call_GroupsListByProject_568214 = ref object of OpenApiRestCall_567659
proc url_GroupsListByProject_568216(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsListByProject_568215(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get all groups created in the project. Returns a json array of objects of type 'group' as specified in the Models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568217 = path.getOrDefault("resourceGroupName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "resourceGroupName", valid_568217
  var valid_568218 = path.getOrDefault("subscriptionId")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "subscriptionId", valid_568218
  var valid_568219 = path.getOrDefault("projectName")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "projectName", valid_568219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568220 = query.getOrDefault("api-version")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568220 != nil:
    section.add "api-version", valid_568220
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568221 = header.getOrDefault("Accept-Language")
  valid_568221 = validateParameter(valid_568221, JString, required = false,
                                 default = nil)
  if valid_568221 != nil:
    section.add "Accept-Language", valid_568221
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_GroupsListByProject_568214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all groups created in the project. Returns a json array of objects of type 'group' as specified in the Models section.
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_GroupsListByProject_568214; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## groupsListByProject
  ## Get all groups created in the project. Returns a json array of objects of type 'group' as specified in the Models section.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  add(path_568224, "resourceGroupName", newJString(resourceGroupName))
  add(query_568225, "api-version", newJString(apiVersion))
  add(path_568224, "subscriptionId", newJString(subscriptionId))
  add(path_568224, "projectName", newJString(projectName))
  result = call_568223.call(path_568224, query_568225, nil, nil, nil)

var groupsListByProject* = Call_GroupsListByProject_568214(
    name: "groupsListByProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups",
    validator: validate_GroupsListByProject_568215, base: "",
    url: url_GroupsListByProject_568216, schemes: {Scheme.Https})
type
  Call_GroupsCreate_568239 = ref object of OpenApiRestCall_567659
proc url_GroupsCreate_568241(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsCreate_568240(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new group by sending a json object of type 'group' as given in Models section as part of the Request Body. The group name in a project is unique. Labels can be applied on a group as part of creation.
  ## 
  ## If a group with the groupName specified in the URL already exists, then this call acts as an update.
  ## 
  ## This operation is Idempotent.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568242 = path.getOrDefault("resourceGroupName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "resourceGroupName", valid_568242
  var valid_568243 = path.getOrDefault("subscriptionId")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "subscriptionId", valid_568243
  var valid_568244 = path.getOrDefault("groupName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "groupName", valid_568244
  var valid_568245 = path.getOrDefault("projectName")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "projectName", valid_568245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568246 = query.getOrDefault("api-version")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568246 != nil:
    section.add "api-version", valid_568246
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568247 = header.getOrDefault("Accept-Language")
  valid_568247 = validateParameter(valid_568247, JString, required = false,
                                 default = nil)
  if valid_568247 != nil:
    section.add "Accept-Language", valid_568247
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   group: JObject
  ##        : New or Updated Group object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568249: Call_GroupsCreate_568239; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new group by sending a json object of type 'group' as given in Models section as part of the Request Body. The group name in a project is unique. Labels can be applied on a group as part of creation.
  ## 
  ## If a group with the groupName specified in the URL already exists, then this call acts as an update.
  ## 
  ## This operation is Idempotent.
  ## 
  ## 
  let valid = call_568249.validator(path, query, header, formData, body)
  let scheme = call_568249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568249.url(scheme.get, call_568249.host, call_568249.base,
                         call_568249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568249, url, valid)

proc call*(call_568250: Call_GroupsCreate_568239; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"; group: JsonNode = nil): Recallable =
  ## groupsCreate
  ## Create a new group by sending a json object of type 'group' as given in Models section as part of the Request Body. The group name in a project is unique. Labels can be applied on a group as part of creation.
  ## 
  ## If a group with the groupName specified in the URL already exists, then this call acts as an update.
  ## 
  ## This operation is Idempotent.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   group: JObject
  ##        : New or Updated Group object.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568251 = newJObject()
  var query_568252 = newJObject()
  var body_568253 = newJObject()
  add(path_568251, "resourceGroupName", newJString(resourceGroupName))
  add(query_568252, "api-version", newJString(apiVersion))
  if group != nil:
    body_568253 = group
  add(path_568251, "subscriptionId", newJString(subscriptionId))
  add(path_568251, "groupName", newJString(groupName))
  add(path_568251, "projectName", newJString(projectName))
  result = call_568250.call(path_568251, query_568252, nil, nil, body_568253)

var groupsCreate* = Call_GroupsCreate_568239(name: "groupsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}",
    validator: validate_GroupsCreate_568240, base: "", url: url_GroupsCreate_568241,
    schemes: {Scheme.Https})
type
  Call_GroupsGet_568226 = ref object of OpenApiRestCall_567659
proc url_GroupsGet_568228(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsGet_568227(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information related to a specific group in the project. Returns a json object of type 'group' as specified in the models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568229 = path.getOrDefault("resourceGroupName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "resourceGroupName", valid_568229
  var valid_568230 = path.getOrDefault("subscriptionId")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "subscriptionId", valid_568230
  var valid_568231 = path.getOrDefault("groupName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "groupName", valid_568231
  var valid_568232 = path.getOrDefault("projectName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "projectName", valid_568232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568233 = query.getOrDefault("api-version")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568233 != nil:
    section.add "api-version", valid_568233
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568234 = header.getOrDefault("Accept-Language")
  valid_568234 = validateParameter(valid_568234, JString, required = false,
                                 default = nil)
  if valid_568234 != nil:
    section.add "Accept-Language", valid_568234
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568235: Call_GroupsGet_568226; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific group in the project. Returns a json object of type 'group' as specified in the models section.
  ## 
  let valid = call_568235.validator(path, query, header, formData, body)
  let scheme = call_568235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568235.url(scheme.get, call_568235.host, call_568235.base,
                         call_568235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568235, url, valid)

proc call*(call_568236: Call_GroupsGet_568226; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## groupsGet
  ## Get information related to a specific group in the project. Returns a json object of type 'group' as specified in the models section.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568237 = newJObject()
  var query_568238 = newJObject()
  add(path_568237, "resourceGroupName", newJString(resourceGroupName))
  add(query_568238, "api-version", newJString(apiVersion))
  add(path_568237, "subscriptionId", newJString(subscriptionId))
  add(path_568237, "groupName", newJString(groupName))
  add(path_568237, "projectName", newJString(projectName))
  result = call_568236.call(path_568237, query_568238, nil, nil, nil)

var groupsGet* = Call_GroupsGet_568226(name: "groupsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}",
                                    validator: validate_GroupsGet_568227,
                                    base: "", url: url_GroupsGet_568228,
                                    schemes: {Scheme.Https})
type
  Call_GroupsDelete_568254 = ref object of OpenApiRestCall_567659
proc url_GroupsDelete_568256(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsDelete_568255(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the group from the project. The machines remain in the project. Deleting a non-existent group results in a no-operation.
  ## 
  ## A group is an aggregation mechanism for machines in a project. Therefore, deleting group does not delete machines in it.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568257 = path.getOrDefault("resourceGroupName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "resourceGroupName", valid_568257
  var valid_568258 = path.getOrDefault("subscriptionId")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "subscriptionId", valid_568258
  var valid_568259 = path.getOrDefault("groupName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "groupName", valid_568259
  var valid_568260 = path.getOrDefault("projectName")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "projectName", valid_568260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568261 = query.getOrDefault("api-version")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568261 != nil:
    section.add "api-version", valid_568261
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568262 = header.getOrDefault("Accept-Language")
  valid_568262 = validateParameter(valid_568262, JString, required = false,
                                 default = nil)
  if valid_568262 != nil:
    section.add "Accept-Language", valid_568262
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568263: Call_GroupsDelete_568254; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the group from the project. The machines remain in the project. Deleting a non-existent group results in a no-operation.
  ## 
  ## A group is an aggregation mechanism for machines in a project. Therefore, deleting group does not delete machines in it.
  ## 
  ## 
  let valid = call_568263.validator(path, query, header, formData, body)
  let scheme = call_568263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568263.url(scheme.get, call_568263.host, call_568263.base,
                         call_568263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568263, url, valid)

proc call*(call_568264: Call_GroupsDelete_568254; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## groupsDelete
  ## Delete the group from the project. The machines remain in the project. Deleting a non-existent group results in a no-operation.
  ## 
  ## A group is an aggregation mechanism for machines in a project. Therefore, deleting group does not delete machines in it.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568265 = newJObject()
  var query_568266 = newJObject()
  add(path_568265, "resourceGroupName", newJString(resourceGroupName))
  add(query_568266, "api-version", newJString(apiVersion))
  add(path_568265, "subscriptionId", newJString(subscriptionId))
  add(path_568265, "groupName", newJString(groupName))
  add(path_568265, "projectName", newJString(projectName))
  result = call_568264.call(path_568265, query_568266, nil, nil, nil)

var groupsDelete* = Call_GroupsDelete_568254(name: "groupsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}",
    validator: validate_GroupsDelete_568255, base: "", url: url_GroupsDelete_568256,
    schemes: {Scheme.Https})
type
  Call_AssessmentsListByGroup_568267 = ref object of OpenApiRestCall_567659
proc url_AssessmentsListByGroup_568269(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsListByGroup_568268(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all assessments created for the specified group.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568270 = path.getOrDefault("resourceGroupName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "resourceGroupName", valid_568270
  var valid_568271 = path.getOrDefault("subscriptionId")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "subscriptionId", valid_568271
  var valid_568272 = path.getOrDefault("groupName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "groupName", valid_568272
  var valid_568273 = path.getOrDefault("projectName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "projectName", valid_568273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568274 = query.getOrDefault("api-version")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568274 != nil:
    section.add "api-version", valid_568274
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568275 = header.getOrDefault("Accept-Language")
  valid_568275 = validateParameter(valid_568275, JString, required = false,
                                 default = nil)
  if valid_568275 != nil:
    section.add "Accept-Language", valid_568275
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568276: Call_AssessmentsListByGroup_568267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all assessments created for the specified group.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  let valid = call_568276.validator(path, query, header, formData, body)
  let scheme = call_568276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568276.url(scheme.get, call_568276.host, call_568276.base,
                         call_568276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568276, url, valid)

proc call*(call_568277: Call_AssessmentsListByGroup_568267;
          resourceGroupName: string; subscriptionId: string; groupName: string;
          projectName: string; apiVersion: string = "2017-11-11-preview"): Recallable =
  ## assessmentsListByGroup
  ## Get all assessments created for the specified group.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568278 = newJObject()
  var query_568279 = newJObject()
  add(path_568278, "resourceGroupName", newJString(resourceGroupName))
  add(query_568279, "api-version", newJString(apiVersion))
  add(path_568278, "subscriptionId", newJString(subscriptionId))
  add(path_568278, "groupName", newJString(groupName))
  add(path_568278, "projectName", newJString(projectName))
  result = call_568277.call(path_568278, query_568279, nil, nil, nil)

var assessmentsListByGroup* = Call_AssessmentsListByGroup_568267(
    name: "assessmentsListByGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments",
    validator: validate_AssessmentsListByGroup_568268, base: "",
    url: url_AssessmentsListByGroup_568269, schemes: {Scheme.Https})
type
  Call_AssessmentsCreate_568294 = ref object of OpenApiRestCall_567659
proc url_AssessmentsCreate_568296(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsCreate_568295(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Create a new assessment with the given name and the specified settings. Since name of an assessment in a project is a unique identifier, if an assessment with the name provided already exists, then the existing assessment is updated.
  ## 
  ## Any PUT operation, resulting in either create or update on an assessment, will cause the assessment to go in a "InProgress" state. This will be indicated by the field 'computationState' on the Assessment object. During this time no other PUT operation will be allowed on that assessment object, nor will a Delete operation. Once the computation for the assessment is complete, the field 'computationState' will be updated to 'Ready', and then other PUT or DELETE operations can happen on the assessment.
  ## 
  ## When assessment is under computation, any PUT will lead to a 400 - Bad Request error.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568297 = path.getOrDefault("resourceGroupName")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "resourceGroupName", valid_568297
  var valid_568298 = path.getOrDefault("subscriptionId")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "subscriptionId", valid_568298
  var valid_568299 = path.getOrDefault("groupName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "groupName", valid_568299
  var valid_568300 = path.getOrDefault("projectName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "projectName", valid_568300
  var valid_568301 = path.getOrDefault("assessmentName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "assessmentName", valid_568301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568302 = query.getOrDefault("api-version")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568302 != nil:
    section.add "api-version", valid_568302
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568303 = header.getOrDefault("Accept-Language")
  valid_568303 = validateParameter(valid_568303, JString, required = false,
                                 default = nil)
  if valid_568303 != nil:
    section.add "Accept-Language", valid_568303
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   assessment: JObject
  ##             : New or Updated Assessment object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568305: Call_AssessmentsCreate_568294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new assessment with the given name and the specified settings. Since name of an assessment in a project is a unique identifier, if an assessment with the name provided already exists, then the existing assessment is updated.
  ## 
  ## Any PUT operation, resulting in either create or update on an assessment, will cause the assessment to go in a "InProgress" state. This will be indicated by the field 'computationState' on the Assessment object. During this time no other PUT operation will be allowed on that assessment object, nor will a Delete operation. Once the computation for the assessment is complete, the field 'computationState' will be updated to 'Ready', and then other PUT or DELETE operations can happen on the assessment.
  ## 
  ## When assessment is under computation, any PUT will lead to a 400 - Bad Request error.
  ## 
  ## 
  let valid = call_568305.validator(path, query, header, formData, body)
  let scheme = call_568305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568305.url(scheme.get, call_568305.host, call_568305.base,
                         call_568305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568305, url, valid)

proc call*(call_568306: Call_AssessmentsCreate_568294; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          assessmentName: string; apiVersion: string = "2017-11-11-preview";
          assessment: JsonNode = nil): Recallable =
  ## assessmentsCreate
  ## Create a new assessment with the given name and the specified settings. Since name of an assessment in a project is a unique identifier, if an assessment with the name provided already exists, then the existing assessment is updated.
  ## 
  ## Any PUT operation, resulting in either create or update on an assessment, will cause the assessment to go in a "InProgress" state. This will be indicated by the field 'computationState' on the Assessment object. During this time no other PUT operation will be allowed on that assessment object, nor will a Delete operation. Once the computation for the assessment is complete, the field 'computationState' will be updated to 'Ready', and then other PUT or DELETE operations can happen on the assessment.
  ## 
  ## When assessment is under computation, any PUT will lead to a 400 - Bad Request error.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   assessment: JObject
  ##             : New or Updated Assessment object.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_568307 = newJObject()
  var query_568308 = newJObject()
  var body_568309 = newJObject()
  add(path_568307, "resourceGroupName", newJString(resourceGroupName))
  add(query_568308, "api-version", newJString(apiVersion))
  if assessment != nil:
    body_568309 = assessment
  add(path_568307, "subscriptionId", newJString(subscriptionId))
  add(path_568307, "groupName", newJString(groupName))
  add(path_568307, "projectName", newJString(projectName))
  add(path_568307, "assessmentName", newJString(assessmentName))
  result = call_568306.call(path_568307, query_568308, nil, nil, body_568309)

var assessmentsCreate* = Call_AssessmentsCreate_568294(name: "assessmentsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}",
    validator: validate_AssessmentsCreate_568295, base: "",
    url: url_AssessmentsCreate_568296, schemes: {Scheme.Https})
type
  Call_AssessmentsGet_568280 = ref object of OpenApiRestCall_567659
proc url_AssessmentsGet_568282(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsGet_568281(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get an existing assessment with the specified name. Returns a json object of type 'assessment' as specified in Models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568283 = path.getOrDefault("resourceGroupName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "resourceGroupName", valid_568283
  var valid_568284 = path.getOrDefault("subscriptionId")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "subscriptionId", valid_568284
  var valid_568285 = path.getOrDefault("groupName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "groupName", valid_568285
  var valid_568286 = path.getOrDefault("projectName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "projectName", valid_568286
  var valid_568287 = path.getOrDefault("assessmentName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "assessmentName", valid_568287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568288 = query.getOrDefault("api-version")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568288 != nil:
    section.add "api-version", valid_568288
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568289 = header.getOrDefault("Accept-Language")
  valid_568289 = validateParameter(valid_568289, JString, required = false,
                                 default = nil)
  if valid_568289 != nil:
    section.add "Accept-Language", valid_568289
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568290: Call_AssessmentsGet_568280; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an existing assessment with the specified name. Returns a json object of type 'assessment' as specified in Models section.
  ## 
  let valid = call_568290.validator(path, query, header, formData, body)
  let scheme = call_568290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568290.url(scheme.get, call_568290.host, call_568290.base,
                         call_568290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568290, url, valid)

proc call*(call_568291: Call_AssessmentsGet_568280; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          assessmentName: string; apiVersion: string = "2017-11-11-preview"): Recallable =
  ## assessmentsGet
  ## Get an existing assessment with the specified name. Returns a json object of type 'assessment' as specified in Models section.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_568292 = newJObject()
  var query_568293 = newJObject()
  add(path_568292, "resourceGroupName", newJString(resourceGroupName))
  add(query_568293, "api-version", newJString(apiVersion))
  add(path_568292, "subscriptionId", newJString(subscriptionId))
  add(path_568292, "groupName", newJString(groupName))
  add(path_568292, "projectName", newJString(projectName))
  add(path_568292, "assessmentName", newJString(assessmentName))
  result = call_568291.call(path_568292, query_568293, nil, nil, nil)

var assessmentsGet* = Call_AssessmentsGet_568280(name: "assessmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}",
    validator: validate_AssessmentsGet_568281, base: "", url: url_AssessmentsGet_568282,
    schemes: {Scheme.Https})
type
  Call_AssessmentsDelete_568310 = ref object of OpenApiRestCall_567659
proc url_AssessmentsDelete_568312(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsDelete_568311(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete an assessment from the project. The machines remain in the assessment. Deleting a non-existent assessment results in a no-operation.
  ## 
  ## When an assessment is under computation, as indicated by the 'computationState' field, it cannot be deleted. Any such attempt will return a 400 - Bad Request.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568313 = path.getOrDefault("resourceGroupName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "resourceGroupName", valid_568313
  var valid_568314 = path.getOrDefault("subscriptionId")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "subscriptionId", valid_568314
  var valid_568315 = path.getOrDefault("groupName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "groupName", valid_568315
  var valid_568316 = path.getOrDefault("projectName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "projectName", valid_568316
  var valid_568317 = path.getOrDefault("assessmentName")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "assessmentName", valid_568317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568318 = query.getOrDefault("api-version")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568318 != nil:
    section.add "api-version", valid_568318
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568319 = header.getOrDefault("Accept-Language")
  valid_568319 = validateParameter(valid_568319, JString, required = false,
                                 default = nil)
  if valid_568319 != nil:
    section.add "Accept-Language", valid_568319
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568320: Call_AssessmentsDelete_568310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an assessment from the project. The machines remain in the assessment. Deleting a non-existent assessment results in a no-operation.
  ## 
  ## When an assessment is under computation, as indicated by the 'computationState' field, it cannot be deleted. Any such attempt will return a 400 - Bad Request.
  ## 
  ## 
  let valid = call_568320.validator(path, query, header, formData, body)
  let scheme = call_568320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568320.url(scheme.get, call_568320.host, call_568320.base,
                         call_568320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568320, url, valid)

proc call*(call_568321: Call_AssessmentsDelete_568310; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          assessmentName: string; apiVersion: string = "2017-11-11-preview"): Recallable =
  ## assessmentsDelete
  ## Delete an assessment from the project. The machines remain in the assessment. Deleting a non-existent assessment results in a no-operation.
  ## 
  ## When an assessment is under computation, as indicated by the 'computationState' field, it cannot be deleted. Any such attempt will return a 400 - Bad Request.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_568322 = newJObject()
  var query_568323 = newJObject()
  add(path_568322, "resourceGroupName", newJString(resourceGroupName))
  add(query_568323, "api-version", newJString(apiVersion))
  add(path_568322, "subscriptionId", newJString(subscriptionId))
  add(path_568322, "groupName", newJString(groupName))
  add(path_568322, "projectName", newJString(projectName))
  add(path_568322, "assessmentName", newJString(assessmentName))
  result = call_568321.call(path_568322, query_568323, nil, nil, nil)

var assessmentsDelete* = Call_AssessmentsDelete_568310(name: "assessmentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}",
    validator: validate_AssessmentsDelete_568311, base: "",
    url: url_AssessmentsDelete_568312, schemes: {Scheme.Https})
type
  Call_AssessedMachinesListByAssessment_568324 = ref object of OpenApiRestCall_567659
proc url_AssessedMachinesListByAssessment_568326(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName"),
               (kind: ConstantSegment, value: "/assessedMachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessedMachinesListByAssessment_568325(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get list of machines that assessed as part of the specified assessment. Returns a json array of objects of type 'assessedMachine' as specified in the Models section.
  ## 
  ## Whenever an assessment is created or updated, it goes under computation. During this phase, the 'status' field of Assessment object reports 'Computing'.
  ## During the period when the assessment is under computation, the list of assessed machines is empty and no assessed machines are returned by this call.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568327 = path.getOrDefault("resourceGroupName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "resourceGroupName", valid_568327
  var valid_568328 = path.getOrDefault("subscriptionId")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "subscriptionId", valid_568328
  var valid_568329 = path.getOrDefault("groupName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "groupName", valid_568329
  var valid_568330 = path.getOrDefault("projectName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "projectName", valid_568330
  var valid_568331 = path.getOrDefault("assessmentName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "assessmentName", valid_568331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568332 = query.getOrDefault("api-version")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568332 != nil:
    section.add "api-version", valid_568332
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568333 = header.getOrDefault("Accept-Language")
  valid_568333 = validateParameter(valid_568333, JString, required = false,
                                 default = nil)
  if valid_568333 != nil:
    section.add "Accept-Language", valid_568333
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568334: Call_AssessedMachinesListByAssessment_568324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get list of machines that assessed as part of the specified assessment. Returns a json array of objects of type 'assessedMachine' as specified in the Models section.
  ## 
  ## Whenever an assessment is created or updated, it goes under computation. During this phase, the 'status' field of Assessment object reports 'Computing'.
  ## During the period when the assessment is under computation, the list of assessed machines is empty and no assessed machines are returned by this call.
  ## 
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_AssessedMachinesListByAssessment_568324;
          resourceGroupName: string; subscriptionId: string; groupName: string;
          projectName: string; assessmentName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## assessedMachinesListByAssessment
  ## Get list of machines that assessed as part of the specified assessment. Returns a json array of objects of type 'assessedMachine' as specified in the Models section.
  ## 
  ## Whenever an assessment is created or updated, it goes under computation. During this phase, the 'status' field of Assessment object reports 'Computing'.
  ## During the period when the assessment is under computation, the list of assessed machines is empty and no assessed machines are returned by this call.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_568336 = newJObject()
  var query_568337 = newJObject()
  add(path_568336, "resourceGroupName", newJString(resourceGroupName))
  add(query_568337, "api-version", newJString(apiVersion))
  add(path_568336, "subscriptionId", newJString(subscriptionId))
  add(path_568336, "groupName", newJString(groupName))
  add(path_568336, "projectName", newJString(projectName))
  add(path_568336, "assessmentName", newJString(assessmentName))
  result = call_568335.call(path_568336, query_568337, nil, nil, nil)

var assessedMachinesListByAssessment* = Call_AssessedMachinesListByAssessment_568324(
    name: "assessedMachinesListByAssessment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}/assessedMachines",
    validator: validate_AssessedMachinesListByAssessment_568325, base: "",
    url: url_AssessedMachinesListByAssessment_568326, schemes: {Scheme.Https})
type
  Call_AssessedMachinesGet_568338 = ref object of OpenApiRestCall_567659
proc url_AssessedMachinesGet_568340(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  assert "assessedMachineName" in path,
        "`assessedMachineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName"),
               (kind: ConstantSegment, value: "/assessedMachines/"),
               (kind: VariableSegment, value: "assessedMachineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessedMachinesGet_568339(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get an assessed machine with its size & cost estimate that was evaluated in the specified assessment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   assessedMachineName: JString (required)
  ##                      : Unique name of an assessed machine evaluated as part of an assessment.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568341 = path.getOrDefault("resourceGroupName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "resourceGroupName", valid_568341
  var valid_568342 = path.getOrDefault("assessedMachineName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "assessedMachineName", valid_568342
  var valid_568343 = path.getOrDefault("subscriptionId")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "subscriptionId", valid_568343
  var valid_568344 = path.getOrDefault("groupName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "groupName", valid_568344
  var valid_568345 = path.getOrDefault("projectName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "projectName", valid_568345
  var valid_568346 = path.getOrDefault("assessmentName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "assessmentName", valid_568346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568347 = query.getOrDefault("api-version")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568347 != nil:
    section.add "api-version", valid_568347
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568348 = header.getOrDefault("Accept-Language")
  valid_568348 = validateParameter(valid_568348, JString, required = false,
                                 default = nil)
  if valid_568348 != nil:
    section.add "Accept-Language", valid_568348
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568349: Call_AssessedMachinesGet_568338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an assessed machine with its size & cost estimate that was evaluated in the specified assessment.
  ## 
  let valid = call_568349.validator(path, query, header, formData, body)
  let scheme = call_568349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568349.url(scheme.get, call_568349.host, call_568349.base,
                         call_568349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568349, url, valid)

proc call*(call_568350: Call_AssessedMachinesGet_568338; resourceGroupName: string;
          assessedMachineName: string; subscriptionId: string; groupName: string;
          projectName: string; assessmentName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## assessedMachinesGet
  ## Get an assessed machine with its size & cost estimate that was evaluated in the specified assessment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   assessedMachineName: string (required)
  ##                      : Unique name of an assessed machine evaluated as part of an assessment.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_568351 = newJObject()
  var query_568352 = newJObject()
  add(path_568351, "resourceGroupName", newJString(resourceGroupName))
  add(query_568352, "api-version", newJString(apiVersion))
  add(path_568351, "assessedMachineName", newJString(assessedMachineName))
  add(path_568351, "subscriptionId", newJString(subscriptionId))
  add(path_568351, "groupName", newJString(groupName))
  add(path_568351, "projectName", newJString(projectName))
  add(path_568351, "assessmentName", newJString(assessmentName))
  result = call_568350.call(path_568351, query_568352, nil, nil, nil)

var assessedMachinesGet* = Call_AssessedMachinesGet_568338(
    name: "assessedMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}/assessedMachines/{assessedMachineName}",
    validator: validate_AssessedMachinesGet_568339, base: "",
    url: url_AssessedMachinesGet_568340, schemes: {Scheme.Https})
type
  Call_AssessmentsGetReportDownloadUrl_568353 = ref object of OpenApiRestCall_567659
proc url_AssessmentsGetReportDownloadUrl_568355(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName"),
               (kind: ConstantSegment, value: "/downloadUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsGetReportDownloadUrl_568354(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the URL for downloading the assessment in a report format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568356 = path.getOrDefault("resourceGroupName")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "resourceGroupName", valid_568356
  var valid_568357 = path.getOrDefault("subscriptionId")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "subscriptionId", valid_568357
  var valid_568358 = path.getOrDefault("groupName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "groupName", valid_568358
  var valid_568359 = path.getOrDefault("projectName")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "projectName", valid_568359
  var valid_568360 = path.getOrDefault("assessmentName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "assessmentName", valid_568360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568361 = query.getOrDefault("api-version")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568361 != nil:
    section.add "api-version", valid_568361
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568362 = header.getOrDefault("Accept-Language")
  valid_568362 = validateParameter(valid_568362, JString, required = false,
                                 default = nil)
  if valid_568362 != nil:
    section.add "Accept-Language", valid_568362
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568363: Call_AssessmentsGetReportDownloadUrl_568353;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the URL for downloading the assessment in a report format.
  ## 
  let valid = call_568363.validator(path, query, header, formData, body)
  let scheme = call_568363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568363.url(scheme.get, call_568363.host, call_568363.base,
                         call_568363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568363, url, valid)

proc call*(call_568364: Call_AssessmentsGetReportDownloadUrl_568353;
          resourceGroupName: string; subscriptionId: string; groupName: string;
          projectName: string; assessmentName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## assessmentsGetReportDownloadUrl
  ## Get the URL for downloading the assessment in a report format.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_568365 = newJObject()
  var query_568366 = newJObject()
  add(path_568365, "resourceGroupName", newJString(resourceGroupName))
  add(query_568366, "api-version", newJString(apiVersion))
  add(path_568365, "subscriptionId", newJString(subscriptionId))
  add(path_568365, "groupName", newJString(groupName))
  add(path_568365, "projectName", newJString(projectName))
  add(path_568365, "assessmentName", newJString(assessmentName))
  result = call_568364.call(path_568365, query_568366, nil, nil, nil)

var assessmentsGetReportDownloadUrl* = Call_AssessmentsGetReportDownloadUrl_568353(
    name: "assessmentsGetReportDownloadUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}/downloadUrl",
    validator: validate_AssessmentsGetReportDownloadUrl_568354, base: "",
    url: url_AssessmentsGetReportDownloadUrl_568355, schemes: {Scheme.Https})
type
  Call_MachinesListByProject_568367 = ref object of OpenApiRestCall_567659
proc url_MachinesListByProject_568369(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/machines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesListByProject_568368(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get data of all the machines available in the project. Returns a json array of objects of type 'machine' defined in Models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568370 = path.getOrDefault("resourceGroupName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "resourceGroupName", valid_568370
  var valid_568371 = path.getOrDefault("subscriptionId")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "subscriptionId", valid_568371
  var valid_568372 = path.getOrDefault("projectName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "projectName", valid_568372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568373 = query.getOrDefault("api-version")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568373 != nil:
    section.add "api-version", valid_568373
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568374 = header.getOrDefault("Accept-Language")
  valid_568374 = validateParameter(valid_568374, JString, required = false,
                                 default = nil)
  if valid_568374 != nil:
    section.add "Accept-Language", valid_568374
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568375: Call_MachinesListByProject_568367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get data of all the machines available in the project. Returns a json array of objects of type 'machine' defined in Models section.
  ## 
  let valid = call_568375.validator(path, query, header, formData, body)
  let scheme = call_568375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568375.url(scheme.get, call_568375.host, call_568375.base,
                         call_568375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568375, url, valid)

proc call*(call_568376: Call_MachinesListByProject_568367;
          resourceGroupName: string; subscriptionId: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## machinesListByProject
  ## Get data of all the machines available in the project. Returns a json array of objects of type 'machine' defined in Models section.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568377 = newJObject()
  var query_568378 = newJObject()
  add(path_568377, "resourceGroupName", newJString(resourceGroupName))
  add(query_568378, "api-version", newJString(apiVersion))
  add(path_568377, "subscriptionId", newJString(subscriptionId))
  add(path_568377, "projectName", newJString(projectName))
  result = call_568376.call(path_568377, query_568378, nil, nil, nil)

var machinesListByProject* = Call_MachinesListByProject_568367(
    name: "machinesListByProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/machines",
    validator: validate_MachinesListByProject_568368, base: "",
    url: url_MachinesListByProject_568369, schemes: {Scheme.Https})
type
  Call_MachinesGet_568379 = ref object of OpenApiRestCall_567659
proc url_MachinesGet_568381(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/machines/"),
               (kind: VariableSegment, value: "machineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesGet_568380(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the machine with the specified name. Returns a json object of type 'machine' defined in Models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   machineName: JString (required)
  ##              : Unique name of a machine in private datacenter.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568382 = path.getOrDefault("resourceGroupName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "resourceGroupName", valid_568382
  var valid_568383 = path.getOrDefault("machineName")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "machineName", valid_568383
  var valid_568384 = path.getOrDefault("subscriptionId")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "subscriptionId", valid_568384
  var valid_568385 = path.getOrDefault("projectName")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "projectName", valid_568385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568386 = query.getOrDefault("api-version")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568386 != nil:
    section.add "api-version", valid_568386
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568387 = header.getOrDefault("Accept-Language")
  valid_568387 = validateParameter(valid_568387, JString, required = false,
                                 default = nil)
  if valid_568387 != nil:
    section.add "Accept-Language", valid_568387
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568388: Call_MachinesGet_568379; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the machine with the specified name. Returns a json object of type 'machine' defined in Models section.
  ## 
  let valid = call_568388.validator(path, query, header, formData, body)
  let scheme = call_568388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568388.url(scheme.get, call_568388.host, call_568388.base,
                         call_568388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568388, url, valid)

proc call*(call_568389: Call_MachinesGet_568379; resourceGroupName: string;
          machineName: string; subscriptionId: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## machinesGet
  ## Get the machine with the specified name. Returns a json object of type 'machine' defined in Models section.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   machineName: string (required)
  ##              : Unique name of a machine in private datacenter.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568390 = newJObject()
  var query_568391 = newJObject()
  add(path_568390, "resourceGroupName", newJString(resourceGroupName))
  add(query_568391, "api-version", newJString(apiVersion))
  add(path_568390, "machineName", newJString(machineName))
  add(path_568390, "subscriptionId", newJString(subscriptionId))
  add(path_568390, "projectName", newJString(projectName))
  result = call_568389.call(path_568390, query_568391, nil, nil, nil)

var machinesGet* = Call_MachinesGet_568379(name: "machinesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/machines/{machineName}",
                                        validator: validate_MachinesGet_568380,
                                        base: "", url: url_MachinesGet_568381,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsList_568392 = ref object of OpenApiRestCall_567659
proc url_ProjectsList_568394(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsList_568393(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the projects in the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568395 = path.getOrDefault("resourceGroupName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "resourceGroupName", valid_568395
  var valid_568396 = path.getOrDefault("subscriptionId")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "subscriptionId", valid_568396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568397 = query.getOrDefault("api-version")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
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
  if body != nil:
    result.add "body", body

proc call*(call_568399: Call_ProjectsList_568392; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the projects in the resource group.
  ## 
  let valid = call_568399.validator(path, query, header, formData, body)
  let scheme = call_568399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568399.url(scheme.get, call_568399.host, call_568399.base,
                         call_568399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568399, url, valid)

proc call*(call_568400: Call_ProjectsList_568392; resourceGroupName: string;
          subscriptionId: string; apiVersion: string = "2017-11-11-preview"): Recallable =
  ## projectsList
  ## Get all the projects in the resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  var path_568401 = newJObject()
  var query_568402 = newJObject()
  add(path_568401, "resourceGroupName", newJString(resourceGroupName))
  add(query_568402, "api-version", newJString(apiVersion))
  add(path_568401, "subscriptionId", newJString(subscriptionId))
  result = call_568400.call(path_568401, query_568402, nil, nil, nil)

var projectsList* = Call_ProjectsList_568392(name: "projectsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects",
    validator: validate_ProjectsList_568393, base: "", url: url_ProjectsList_568394,
    schemes: {Scheme.Https})
type
  Call_ProjectsCreate_568415 = ref object of OpenApiRestCall_567659
proc url_ProjectsCreate_568417(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsCreate_568416(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create a project with specified name. If a project already exists, update it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568418 = path.getOrDefault("resourceGroupName")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "resourceGroupName", valid_568418
  var valid_568419 = path.getOrDefault("subscriptionId")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "subscriptionId", valid_568419
  var valid_568420 = path.getOrDefault("projectName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "projectName", valid_568420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568421 = query.getOrDefault("api-version")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568421 != nil:
    section.add "api-version", valid_568421
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568422 = header.getOrDefault("Accept-Language")
  valid_568422 = validateParameter(valid_568422, JString, required = false,
                                 default = nil)
  if valid_568422 != nil:
    section.add "Accept-Language", valid_568422
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   project: JObject
  ##          : New or Updated project object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568424: Call_ProjectsCreate_568415; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a project with specified name. If a project already exists, update it.
  ## 
  let valid = call_568424.validator(path, query, header, formData, body)
  let scheme = call_568424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568424.url(scheme.get, call_568424.host, call_568424.base,
                         call_568424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568424, url, valid)

proc call*(call_568425: Call_ProjectsCreate_568415; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"; project: JsonNode = nil): Recallable =
  ## projectsCreate
  ## Create a project with specified name. If a project already exists, update it.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   project: JObject
  ##          : New or Updated project object.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568426 = newJObject()
  var query_568427 = newJObject()
  var body_568428 = newJObject()
  add(path_568426, "resourceGroupName", newJString(resourceGroupName))
  add(query_568427, "api-version", newJString(apiVersion))
  add(path_568426, "subscriptionId", newJString(subscriptionId))
  if project != nil:
    body_568428 = project
  add(path_568426, "projectName", newJString(projectName))
  result = call_568425.call(path_568426, query_568427, nil, nil, body_568428)

var projectsCreate* = Call_ProjectsCreate_568415(name: "projectsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
    validator: validate_ProjectsCreate_568416, base: "", url: url_ProjectsCreate_568417,
    schemes: {Scheme.Https})
type
  Call_ProjectsGet_568403 = ref object of OpenApiRestCall_567659
proc url_ProjectsGet_568405(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsGet_568404(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the project with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568406 = path.getOrDefault("resourceGroupName")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "resourceGroupName", valid_568406
  var valid_568407 = path.getOrDefault("subscriptionId")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "subscriptionId", valid_568407
  var valid_568408 = path.getOrDefault("projectName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "projectName", valid_568408
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568409 = query.getOrDefault("api-version")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568409 != nil:
    section.add "api-version", valid_568409
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568410 = header.getOrDefault("Accept-Language")
  valid_568410 = validateParameter(valid_568410, JString, required = false,
                                 default = nil)
  if valid_568410 != nil:
    section.add "Accept-Language", valid_568410
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568411: Call_ProjectsGet_568403; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the project with the specified name.
  ## 
  let valid = call_568411.validator(path, query, header, formData, body)
  let scheme = call_568411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568411.url(scheme.get, call_568411.host, call_568411.base,
                         call_568411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568411, url, valid)

proc call*(call_568412: Call_ProjectsGet_568403; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## projectsGet
  ## Get the project with the specified name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568413 = newJObject()
  var query_568414 = newJObject()
  add(path_568413, "resourceGroupName", newJString(resourceGroupName))
  add(query_568414, "api-version", newJString(apiVersion))
  add(path_568413, "subscriptionId", newJString(subscriptionId))
  add(path_568413, "projectName", newJString(projectName))
  result = call_568412.call(path_568413, query_568414, nil, nil, nil)

var projectsGet* = Call_ProjectsGet_568403(name: "projectsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
                                        validator: validate_ProjectsGet_568404,
                                        base: "", url: url_ProjectsGet_568405,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsUpdate_568441 = ref object of OpenApiRestCall_567659
proc url_ProjectsUpdate_568443(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsUpdate_568442(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update a project with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568444 = path.getOrDefault("resourceGroupName")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "resourceGroupName", valid_568444
  var valid_568445 = path.getOrDefault("subscriptionId")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "subscriptionId", valid_568445
  var valid_568446 = path.getOrDefault("projectName")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "projectName", valid_568446
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568447 = query.getOrDefault("api-version")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568447 != nil:
    section.add "api-version", valid_568447
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568448 = header.getOrDefault("Accept-Language")
  valid_568448 = validateParameter(valid_568448, JString, required = false,
                                 default = nil)
  if valid_568448 != nil:
    section.add "Accept-Language", valid_568448
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   project: JObject
  ##          : Updated project object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568450: Call_ProjectsUpdate_568441; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a project with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  let valid = call_568450.validator(path, query, header, formData, body)
  let scheme = call_568450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568450.url(scheme.get, call_568450.host, call_568450.base,
                         call_568450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568450, url, valid)

proc call*(call_568451: Call_ProjectsUpdate_568441; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"; project: JsonNode = nil): Recallable =
  ## projectsUpdate
  ## Update a project with specified name. Supports partial updates, for example only tags can be provided.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   project: JObject
  ##          : Updated project object.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568452 = newJObject()
  var query_568453 = newJObject()
  var body_568454 = newJObject()
  add(path_568452, "resourceGroupName", newJString(resourceGroupName))
  add(query_568453, "api-version", newJString(apiVersion))
  add(path_568452, "subscriptionId", newJString(subscriptionId))
  if project != nil:
    body_568454 = project
  add(path_568452, "projectName", newJString(projectName))
  result = call_568451.call(path_568452, query_568453, nil, nil, body_568454)

var projectsUpdate* = Call_ProjectsUpdate_568441(name: "projectsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
    validator: validate_ProjectsUpdate_568442, base: "", url: url_ProjectsUpdate_568443,
    schemes: {Scheme.Https})
type
  Call_ProjectsDelete_568429 = ref object of OpenApiRestCall_567659
proc url_ProjectsDelete_568431(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsDelete_568430(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete the project. Deleting non-existent project is a no-operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
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
  var valid_568434 = path.getOrDefault("projectName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "projectName", valid_568434
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568435 = query.getOrDefault("api-version")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568435 != nil:
    section.add "api-version", valid_568435
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568436 = header.getOrDefault("Accept-Language")
  valid_568436 = validateParameter(valid_568436, JString, required = false,
                                 default = nil)
  if valid_568436 != nil:
    section.add "Accept-Language", valid_568436
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568437: Call_ProjectsDelete_568429; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the project. Deleting non-existent project is a no-operation.
  ## 
  let valid = call_568437.validator(path, query, header, formData, body)
  let scheme = call_568437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568437.url(scheme.get, call_568437.host, call_568437.base,
                         call_568437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568437, url, valid)

proc call*(call_568438: Call_ProjectsDelete_568429; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## projectsDelete
  ## Delete the project. Deleting non-existent project is a no-operation.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568439 = newJObject()
  var query_568440 = newJObject()
  add(path_568439, "resourceGroupName", newJString(resourceGroupName))
  add(query_568440, "api-version", newJString(apiVersion))
  add(path_568439, "subscriptionId", newJString(subscriptionId))
  add(path_568439, "projectName", newJString(projectName))
  result = call_568438.call(path_568439, query_568440, nil, nil, nil)

var projectsDelete* = Call_ProjectsDelete_568429(name: "projectsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
    validator: validate_ProjectsDelete_568430, base: "", url: url_ProjectsDelete_568431,
    schemes: {Scheme.Https})
type
  Call_ProjectsGetKeys_568455 = ref object of OpenApiRestCall_567659
proc url_ProjectsGetKeys_568457(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/keys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsGetKeys_568456(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the Log Analytics Workspace ID and Primary Key for the specified project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568458 = path.getOrDefault("resourceGroupName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "resourceGroupName", valid_568458
  var valid_568459 = path.getOrDefault("subscriptionId")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "subscriptionId", valid_568459
  var valid_568460 = path.getOrDefault("projectName")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "projectName", valid_568460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568461 = query.getOrDefault("api-version")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_568461 != nil:
    section.add "api-version", valid_568461
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_568462 = header.getOrDefault("Accept-Language")
  valid_568462 = validateParameter(valid_568462, JString, required = false,
                                 default = nil)
  if valid_568462 != nil:
    section.add "Accept-Language", valid_568462
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568463: Call_ProjectsGetKeys_568455; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Log Analytics Workspace ID and Primary Key for the specified project.
  ## 
  let valid = call_568463.validator(path, query, header, formData, body)
  let scheme = call_568463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568463.url(scheme.get, call_568463.host, call_568463.base,
                         call_568463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568463, url, valid)

proc call*(call_568464: Call_ProjectsGetKeys_568455; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## projectsGetKeys
  ## Gets the Log Analytics Workspace ID and Primary Key for the specified project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_568465 = newJObject()
  var query_568466 = newJObject()
  add(path_568465, "resourceGroupName", newJString(resourceGroupName))
  add(query_568466, "api-version", newJString(apiVersion))
  add(path_568465, "subscriptionId", newJString(subscriptionId))
  add(path_568465, "projectName", newJString(projectName))
  result = call_568464.call(path_568465, query_568466, nil, nil, nil)

var projectsGetKeys* = Call_ProjectsGetKeys_568455(name: "projectsGetKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/keys",
    validator: validate_ProjectsGetKeys_568456, base: "", url: url_ProjectsGetKeys_568457,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
