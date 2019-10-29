
import
  json, options, hashes, uri, rest, os, uri, httpcore

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
  macServiceName = "migrate"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563779 = ref object of OpenApiRestCall_563557
proc url_OperationsList_563781(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563780(path: JsonNode; query: JsonNode;
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

proc call*(call_563886: Call_OperationsList_563779; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  ## 
  let valid = call_563886.validator(path, query, header, formData, body)
  let scheme = call_563886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563886.url(scheme.get, call_563886.host, call_563886.base,
                         call_563886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563886, url, valid)

proc call*(call_563970: Call_OperationsList_563779): Recallable =
  ## operationsList
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  result = call_563970.call(nil, nil, nil, nil, nil)

var operationsList* = Call_OperationsList_563779(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Migrate/operations",
    validator: validate_OperationsList_563780, base: "", url: url_OperationsList_563781,
    schemes: {Scheme.Https})
type
  Call_AssessmentsListByProject_564008 = ref object of OpenApiRestCall_563557
proc url_AssessmentsListByProject_564010(protocol: Scheme; host: string;
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

proc validate_AssessmentsListByProject_564009(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all assessments created in the project.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564090 = path.getOrDefault("subscriptionId")
  valid_564090 = validateParameter(valid_564090, JString, required = true,
                                 default = nil)
  if valid_564090 != nil:
    section.add "subscriptionId", valid_564090
  var valid_564091 = path.getOrDefault("resourceGroupName")
  valid_564091 = validateParameter(valid_564091, JString, required = true,
                                 default = nil)
  if valid_564091 != nil:
    section.add "resourceGroupName", valid_564091
  var valid_564092 = path.getOrDefault("projectName")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = nil)
  if valid_564092 != nil:
    section.add "projectName", valid_564092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564106 = query.getOrDefault("api-version")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564106 != nil:
    section.add "api-version", valid_564106
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564107 = header.getOrDefault("Accept-Language")
  valid_564107 = validateParameter(valid_564107, JString, required = false,
                                 default = nil)
  if valid_564107 != nil:
    section.add "Accept-Language", valid_564107
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564108: Call_AssessmentsListByProject_564008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all assessments created in the project.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_AssessmentsListByProject_564008;
          subscriptionId: string; resourceGroupName: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## assessmentsListByProject
  ## Get all assessments created in the project.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_564110 = newJObject()
  var query_564112 = newJObject()
  add(query_564112, "api-version", newJString(apiVersion))
  add(path_564110, "subscriptionId", newJString(subscriptionId))
  add(path_564110, "resourceGroupName", newJString(resourceGroupName))
  add(path_564110, "projectName", newJString(projectName))
  result = call_564109.call(path_564110, query_564112, nil, nil, nil)

var assessmentsListByProject* = Call_AssessmentsListByProject_564008(
    name: "assessmentsListByProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/assessments",
    validator: validate_AssessmentsListByProject_564009, base: "",
    url: url_AssessmentsListByProject_564010, schemes: {Scheme.Https})
type
  Call_GroupsListByProject_564114 = ref object of OpenApiRestCall_563557
proc url_GroupsListByProject_564116(protocol: Scheme; host: string; base: string;
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

proc validate_GroupsListByProject_564115(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get all groups created in the project. Returns a json array of objects of type 'group' as specified in the Models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564117 = path.getOrDefault("subscriptionId")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "subscriptionId", valid_564117
  var valid_564118 = path.getOrDefault("resourceGroupName")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "resourceGroupName", valid_564118
  var valid_564119 = path.getOrDefault("projectName")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "projectName", valid_564119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564120 = query.getOrDefault("api-version")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564120 != nil:
    section.add "api-version", valid_564120
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564121 = header.getOrDefault("Accept-Language")
  valid_564121 = validateParameter(valid_564121, JString, required = false,
                                 default = nil)
  if valid_564121 != nil:
    section.add "Accept-Language", valid_564121
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564122: Call_GroupsListByProject_564114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all groups created in the project. Returns a json array of objects of type 'group' as specified in the Models section.
  ## 
  let valid = call_564122.validator(path, query, header, formData, body)
  let scheme = call_564122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564122.url(scheme.get, call_564122.host, call_564122.base,
                         call_564122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564122, url, valid)

proc call*(call_564123: Call_GroupsListByProject_564114; subscriptionId: string;
          resourceGroupName: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## groupsListByProject
  ## Get all groups created in the project. Returns a json array of objects of type 'group' as specified in the Models section.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_564124 = newJObject()
  var query_564125 = newJObject()
  add(query_564125, "api-version", newJString(apiVersion))
  add(path_564124, "subscriptionId", newJString(subscriptionId))
  add(path_564124, "resourceGroupName", newJString(resourceGroupName))
  add(path_564124, "projectName", newJString(projectName))
  result = call_564123.call(path_564124, query_564125, nil, nil, nil)

var groupsListByProject* = Call_GroupsListByProject_564114(
    name: "groupsListByProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups",
    validator: validate_GroupsListByProject_564115, base: "",
    url: url_GroupsListByProject_564116, schemes: {Scheme.Https})
type
  Call_GroupsCreate_564139 = ref object of OpenApiRestCall_563557
proc url_GroupsCreate_564141(protocol: Scheme; host: string; base: string;
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

proc validate_GroupsCreate_564140(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564142 = path.getOrDefault("subscriptionId")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "subscriptionId", valid_564142
  var valid_564143 = path.getOrDefault("resourceGroupName")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "resourceGroupName", valid_564143
  var valid_564144 = path.getOrDefault("projectName")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "projectName", valid_564144
  var valid_564145 = path.getOrDefault("groupName")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "groupName", valid_564145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564146 = query.getOrDefault("api-version")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564146 != nil:
    section.add "api-version", valid_564146
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564147 = header.getOrDefault("Accept-Language")
  valid_564147 = validateParameter(valid_564147, JString, required = false,
                                 default = nil)
  if valid_564147 != nil:
    section.add "Accept-Language", valid_564147
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   group: JObject
  ##        : New or Updated Group object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564149: Call_GroupsCreate_564139; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new group by sending a json object of type 'group' as given in Models section as part of the Request Body. The group name in a project is unique. Labels can be applied on a group as part of creation.
  ## 
  ## If a group with the groupName specified in the URL already exists, then this call acts as an update.
  ## 
  ## This operation is Idempotent.
  ## 
  ## 
  let valid = call_564149.validator(path, query, header, formData, body)
  let scheme = call_564149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564149.url(scheme.get, call_564149.host, call_564149.base,
                         call_564149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564149, url, valid)

proc call*(call_564150: Call_GroupsCreate_564139; subscriptionId: string;
          resourceGroupName: string; projectName: string; groupName: string;
          apiVersion: string = "2017-11-11-preview"; group: JsonNode = nil): Recallable =
  ## groupsCreate
  ## Create a new group by sending a json object of type 'group' as given in Models section as part of the Request Body. The group name in a project is unique. Labels can be applied on a group as part of creation.
  ## 
  ## If a group with the groupName specified in the URL already exists, then this call acts as an update.
  ## 
  ## This operation is Idempotent.
  ## 
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   group: JObject
  ##        : New or Updated Group object.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  var path_564151 = newJObject()
  var query_564152 = newJObject()
  var body_564153 = newJObject()
  add(query_564152, "api-version", newJString(apiVersion))
  if group != nil:
    body_564153 = group
  add(path_564151, "subscriptionId", newJString(subscriptionId))
  add(path_564151, "resourceGroupName", newJString(resourceGroupName))
  add(path_564151, "projectName", newJString(projectName))
  add(path_564151, "groupName", newJString(groupName))
  result = call_564150.call(path_564151, query_564152, nil, nil, body_564153)

var groupsCreate* = Call_GroupsCreate_564139(name: "groupsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}",
    validator: validate_GroupsCreate_564140, base: "", url: url_GroupsCreate_564141,
    schemes: {Scheme.Https})
type
  Call_GroupsGet_564126 = ref object of OpenApiRestCall_563557
proc url_GroupsGet_564128(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GroupsGet_564127(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information related to a specific group in the project. Returns a json object of type 'group' as specified in the models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
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
  var valid_564131 = path.getOrDefault("projectName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "projectName", valid_564131
  var valid_564132 = path.getOrDefault("groupName")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "groupName", valid_564132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564133 = query.getOrDefault("api-version")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564133 != nil:
    section.add "api-version", valid_564133
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564134 = header.getOrDefault("Accept-Language")
  valid_564134 = validateParameter(valid_564134, JString, required = false,
                                 default = nil)
  if valid_564134 != nil:
    section.add "Accept-Language", valid_564134
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564135: Call_GroupsGet_564126; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific group in the project. Returns a json object of type 'group' as specified in the models section.
  ## 
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_GroupsGet_564126; subscriptionId: string;
          resourceGroupName: string; projectName: string; groupName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## groupsGet
  ## Get information related to a specific group in the project. Returns a json object of type 'group' as specified in the models section.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  var path_564137 = newJObject()
  var query_564138 = newJObject()
  add(query_564138, "api-version", newJString(apiVersion))
  add(path_564137, "subscriptionId", newJString(subscriptionId))
  add(path_564137, "resourceGroupName", newJString(resourceGroupName))
  add(path_564137, "projectName", newJString(projectName))
  add(path_564137, "groupName", newJString(groupName))
  result = call_564136.call(path_564137, query_564138, nil, nil, nil)

var groupsGet* = Call_GroupsGet_564126(name: "groupsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}",
                                    validator: validate_GroupsGet_564127,
                                    base: "", url: url_GroupsGet_564128,
                                    schemes: {Scheme.Https})
type
  Call_GroupsDelete_564154 = ref object of OpenApiRestCall_563557
proc url_GroupsDelete_564156(protocol: Scheme; host: string; base: string;
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

proc validate_GroupsDelete_564155(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the group from the project. The machines remain in the project. Deleting a non-existent group results in a no-operation.
  ## 
  ## A group is an aggregation mechanism for machines in a project. Therefore, deleting group does not delete machines in it.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564157 = path.getOrDefault("subscriptionId")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "subscriptionId", valid_564157
  var valid_564158 = path.getOrDefault("resourceGroupName")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "resourceGroupName", valid_564158
  var valid_564159 = path.getOrDefault("projectName")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "projectName", valid_564159
  var valid_564160 = path.getOrDefault("groupName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "groupName", valid_564160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564161 = query.getOrDefault("api-version")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564161 != nil:
    section.add "api-version", valid_564161
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564162 = header.getOrDefault("Accept-Language")
  valid_564162 = validateParameter(valid_564162, JString, required = false,
                                 default = nil)
  if valid_564162 != nil:
    section.add "Accept-Language", valid_564162
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564163: Call_GroupsDelete_564154; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the group from the project. The machines remain in the project. Deleting a non-existent group results in a no-operation.
  ## 
  ## A group is an aggregation mechanism for machines in a project. Therefore, deleting group does not delete machines in it.
  ## 
  ## 
  let valid = call_564163.validator(path, query, header, formData, body)
  let scheme = call_564163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564163.url(scheme.get, call_564163.host, call_564163.base,
                         call_564163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564163, url, valid)

proc call*(call_564164: Call_GroupsDelete_564154; subscriptionId: string;
          resourceGroupName: string; projectName: string; groupName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## groupsDelete
  ## Delete the group from the project. The machines remain in the project. Deleting a non-existent group results in a no-operation.
  ## 
  ## A group is an aggregation mechanism for machines in a project. Therefore, deleting group does not delete machines in it.
  ## 
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  var path_564165 = newJObject()
  var query_564166 = newJObject()
  add(query_564166, "api-version", newJString(apiVersion))
  add(path_564165, "subscriptionId", newJString(subscriptionId))
  add(path_564165, "resourceGroupName", newJString(resourceGroupName))
  add(path_564165, "projectName", newJString(projectName))
  add(path_564165, "groupName", newJString(groupName))
  result = call_564164.call(path_564165, query_564166, nil, nil, nil)

var groupsDelete* = Call_GroupsDelete_564154(name: "groupsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}",
    validator: validate_GroupsDelete_564155, base: "", url: url_GroupsDelete_564156,
    schemes: {Scheme.Https})
type
  Call_AssessmentsListByGroup_564167 = ref object of OpenApiRestCall_563557
proc url_AssessmentsListByGroup_564169(protocol: Scheme; host: string; base: string;
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

proc validate_AssessmentsListByGroup_564168(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all assessments created for the specified group.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564170 = path.getOrDefault("subscriptionId")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "subscriptionId", valid_564170
  var valid_564171 = path.getOrDefault("resourceGroupName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "resourceGroupName", valid_564171
  var valid_564172 = path.getOrDefault("projectName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "projectName", valid_564172
  var valid_564173 = path.getOrDefault("groupName")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "groupName", valid_564173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564174 = query.getOrDefault("api-version")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564174 != nil:
    section.add "api-version", valid_564174
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564175 = header.getOrDefault("Accept-Language")
  valid_564175 = validateParameter(valid_564175, JString, required = false,
                                 default = nil)
  if valid_564175 != nil:
    section.add "Accept-Language", valid_564175
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564176: Call_AssessmentsListByGroup_564167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all assessments created for the specified group.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_AssessmentsListByGroup_564167; subscriptionId: string;
          resourceGroupName: string; projectName: string; groupName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## assessmentsListByGroup
  ## Get all assessments created for the specified group.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  var path_564178 = newJObject()
  var query_564179 = newJObject()
  add(query_564179, "api-version", newJString(apiVersion))
  add(path_564178, "subscriptionId", newJString(subscriptionId))
  add(path_564178, "resourceGroupName", newJString(resourceGroupName))
  add(path_564178, "projectName", newJString(projectName))
  add(path_564178, "groupName", newJString(groupName))
  result = call_564177.call(path_564178, query_564179, nil, nil, nil)

var assessmentsListByGroup* = Call_AssessmentsListByGroup_564167(
    name: "assessmentsListByGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments",
    validator: validate_AssessmentsListByGroup_564168, base: "",
    url: url_AssessmentsListByGroup_564169, schemes: {Scheme.Https})
type
  Call_AssessmentsCreate_564194 = ref object of OpenApiRestCall_563557
proc url_AssessmentsCreate_564196(protocol: Scheme; host: string; base: string;
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

proc validate_AssessmentsCreate_564195(path: JsonNode; query: JsonNode;
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
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `assessmentName` field"
  var valid_564197 = path.getOrDefault("assessmentName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "assessmentName", valid_564197
  var valid_564198 = path.getOrDefault("subscriptionId")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "subscriptionId", valid_564198
  var valid_564199 = path.getOrDefault("resourceGroupName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "resourceGroupName", valid_564199
  var valid_564200 = path.getOrDefault("projectName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "projectName", valid_564200
  var valid_564201 = path.getOrDefault("groupName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "groupName", valid_564201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564202 = query.getOrDefault("api-version")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564202 != nil:
    section.add "api-version", valid_564202
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564203 = header.getOrDefault("Accept-Language")
  valid_564203 = validateParameter(valid_564203, JString, required = false,
                                 default = nil)
  if valid_564203 != nil:
    section.add "Accept-Language", valid_564203
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   assessment: JObject
  ##             : New or Updated Assessment object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564205: Call_AssessmentsCreate_564194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new assessment with the given name and the specified settings. Since name of an assessment in a project is a unique identifier, if an assessment with the name provided already exists, then the existing assessment is updated.
  ## 
  ## Any PUT operation, resulting in either create or update on an assessment, will cause the assessment to go in a "InProgress" state. This will be indicated by the field 'computationState' on the Assessment object. During this time no other PUT operation will be allowed on that assessment object, nor will a Delete operation. Once the computation for the assessment is complete, the field 'computationState' will be updated to 'Ready', and then other PUT or DELETE operations can happen on the assessment.
  ## 
  ## When assessment is under computation, any PUT will lead to a 400 - Bad Request error.
  ## 
  ## 
  let valid = call_564205.validator(path, query, header, formData, body)
  let scheme = call_564205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564205.url(scheme.get, call_564205.host, call_564205.base,
                         call_564205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564205, url, valid)

proc call*(call_564206: Call_AssessmentsCreate_564194; assessmentName: string;
          subscriptionId: string; resourceGroupName: string; projectName: string;
          groupName: string; apiVersion: string = "2017-11-11-preview";
          assessment: JsonNode = nil): Recallable =
  ## assessmentsCreate
  ## Create a new assessment with the given name and the specified settings. Since name of an assessment in a project is a unique identifier, if an assessment with the name provided already exists, then the existing assessment is updated.
  ## 
  ## Any PUT operation, resulting in either create or update on an assessment, will cause the assessment to go in a "InProgress" state. This will be indicated by the field 'computationState' on the Assessment object. During this time no other PUT operation will be allowed on that assessment object, nor will a Delete operation. Once the computation for the assessment is complete, the field 'computationState' will be updated to 'Ready', and then other PUT or DELETE operations can happen on the assessment.
  ## 
  ## When assessment is under computation, any PUT will lead to a 400 - Bad Request error.
  ## 
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   assessment: JObject
  ##             : New or Updated Assessment object.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  var path_564207 = newJObject()
  var query_564208 = newJObject()
  var body_564209 = newJObject()
  add(path_564207, "assessmentName", newJString(assessmentName))
  add(query_564208, "api-version", newJString(apiVersion))
  if assessment != nil:
    body_564209 = assessment
  add(path_564207, "subscriptionId", newJString(subscriptionId))
  add(path_564207, "resourceGroupName", newJString(resourceGroupName))
  add(path_564207, "projectName", newJString(projectName))
  add(path_564207, "groupName", newJString(groupName))
  result = call_564206.call(path_564207, query_564208, nil, nil, body_564209)

var assessmentsCreate* = Call_AssessmentsCreate_564194(name: "assessmentsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}",
    validator: validate_AssessmentsCreate_564195, base: "",
    url: url_AssessmentsCreate_564196, schemes: {Scheme.Https})
type
  Call_AssessmentsGet_564180 = ref object of OpenApiRestCall_563557
proc url_AssessmentsGet_564182(protocol: Scheme; host: string; base: string;
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

proc validate_AssessmentsGet_564181(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get an existing assessment with the specified name. Returns a json object of type 'assessment' as specified in Models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `assessmentName` field"
  var valid_564183 = path.getOrDefault("assessmentName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "assessmentName", valid_564183
  var valid_564184 = path.getOrDefault("subscriptionId")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "subscriptionId", valid_564184
  var valid_564185 = path.getOrDefault("resourceGroupName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "resourceGroupName", valid_564185
  var valid_564186 = path.getOrDefault("projectName")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "projectName", valid_564186
  var valid_564187 = path.getOrDefault("groupName")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "groupName", valid_564187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564188 = query.getOrDefault("api-version")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564188 != nil:
    section.add "api-version", valid_564188
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564189 = header.getOrDefault("Accept-Language")
  valid_564189 = validateParameter(valid_564189, JString, required = false,
                                 default = nil)
  if valid_564189 != nil:
    section.add "Accept-Language", valid_564189
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564190: Call_AssessmentsGet_564180; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an existing assessment with the specified name. Returns a json object of type 'assessment' as specified in Models section.
  ## 
  let valid = call_564190.validator(path, query, header, formData, body)
  let scheme = call_564190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564190.url(scheme.get, call_564190.host, call_564190.base,
                         call_564190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564190, url, valid)

proc call*(call_564191: Call_AssessmentsGet_564180; assessmentName: string;
          subscriptionId: string; resourceGroupName: string; projectName: string;
          groupName: string; apiVersion: string = "2017-11-11-preview"): Recallable =
  ## assessmentsGet
  ## Get an existing assessment with the specified name. Returns a json object of type 'assessment' as specified in Models section.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  var path_564192 = newJObject()
  var query_564193 = newJObject()
  add(path_564192, "assessmentName", newJString(assessmentName))
  add(query_564193, "api-version", newJString(apiVersion))
  add(path_564192, "subscriptionId", newJString(subscriptionId))
  add(path_564192, "resourceGroupName", newJString(resourceGroupName))
  add(path_564192, "projectName", newJString(projectName))
  add(path_564192, "groupName", newJString(groupName))
  result = call_564191.call(path_564192, query_564193, nil, nil, nil)

var assessmentsGet* = Call_AssessmentsGet_564180(name: "assessmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}",
    validator: validate_AssessmentsGet_564181, base: "", url: url_AssessmentsGet_564182,
    schemes: {Scheme.Https})
type
  Call_AssessmentsDelete_564210 = ref object of OpenApiRestCall_563557
proc url_AssessmentsDelete_564212(protocol: Scheme; host: string; base: string;
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

proc validate_AssessmentsDelete_564211(path: JsonNode; query: JsonNode;
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
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `assessmentName` field"
  var valid_564213 = path.getOrDefault("assessmentName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "assessmentName", valid_564213
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
  var valid_564216 = path.getOrDefault("projectName")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "projectName", valid_564216
  var valid_564217 = path.getOrDefault("groupName")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "groupName", valid_564217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564218 = query.getOrDefault("api-version")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564218 != nil:
    section.add "api-version", valid_564218
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564219 = header.getOrDefault("Accept-Language")
  valid_564219 = validateParameter(valid_564219, JString, required = false,
                                 default = nil)
  if valid_564219 != nil:
    section.add "Accept-Language", valid_564219
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564220: Call_AssessmentsDelete_564210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an assessment from the project. The machines remain in the assessment. Deleting a non-existent assessment results in a no-operation.
  ## 
  ## When an assessment is under computation, as indicated by the 'computationState' field, it cannot be deleted. Any such attempt will return a 400 - Bad Request.
  ## 
  ## 
  let valid = call_564220.validator(path, query, header, formData, body)
  let scheme = call_564220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564220.url(scheme.get, call_564220.host, call_564220.base,
                         call_564220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564220, url, valid)

proc call*(call_564221: Call_AssessmentsDelete_564210; assessmentName: string;
          subscriptionId: string; resourceGroupName: string; projectName: string;
          groupName: string; apiVersion: string = "2017-11-11-preview"): Recallable =
  ## assessmentsDelete
  ## Delete an assessment from the project. The machines remain in the assessment. Deleting a non-existent assessment results in a no-operation.
  ## 
  ## When an assessment is under computation, as indicated by the 'computationState' field, it cannot be deleted. Any such attempt will return a 400 - Bad Request.
  ## 
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  var path_564222 = newJObject()
  var query_564223 = newJObject()
  add(path_564222, "assessmentName", newJString(assessmentName))
  add(query_564223, "api-version", newJString(apiVersion))
  add(path_564222, "subscriptionId", newJString(subscriptionId))
  add(path_564222, "resourceGroupName", newJString(resourceGroupName))
  add(path_564222, "projectName", newJString(projectName))
  add(path_564222, "groupName", newJString(groupName))
  result = call_564221.call(path_564222, query_564223, nil, nil, nil)

var assessmentsDelete* = Call_AssessmentsDelete_564210(name: "assessmentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}",
    validator: validate_AssessmentsDelete_564211, base: "",
    url: url_AssessmentsDelete_564212, schemes: {Scheme.Https})
type
  Call_AssessedMachinesListByAssessment_564224 = ref object of OpenApiRestCall_563557
proc url_AssessedMachinesListByAssessment_564226(protocol: Scheme; host: string;
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

proc validate_AssessedMachinesListByAssessment_564225(path: JsonNode;
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
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `assessmentName` field"
  var valid_564227 = path.getOrDefault("assessmentName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "assessmentName", valid_564227
  var valid_564228 = path.getOrDefault("subscriptionId")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "subscriptionId", valid_564228
  var valid_564229 = path.getOrDefault("resourceGroupName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "resourceGroupName", valid_564229
  var valid_564230 = path.getOrDefault("projectName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "projectName", valid_564230
  var valid_564231 = path.getOrDefault("groupName")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "groupName", valid_564231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564232 = query.getOrDefault("api-version")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564232 != nil:
    section.add "api-version", valid_564232
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564233 = header.getOrDefault("Accept-Language")
  valid_564233 = validateParameter(valid_564233, JString, required = false,
                                 default = nil)
  if valid_564233 != nil:
    section.add "Accept-Language", valid_564233
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564234: Call_AssessedMachinesListByAssessment_564224;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get list of machines that assessed as part of the specified assessment. Returns a json array of objects of type 'assessedMachine' as specified in the Models section.
  ## 
  ## Whenever an assessment is created or updated, it goes under computation. During this phase, the 'status' field of Assessment object reports 'Computing'.
  ## During the period when the assessment is under computation, the list of assessed machines is empty and no assessed machines are returned by this call.
  ## 
  ## 
  let valid = call_564234.validator(path, query, header, formData, body)
  let scheme = call_564234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564234.url(scheme.get, call_564234.host, call_564234.base,
                         call_564234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564234, url, valid)

proc call*(call_564235: Call_AssessedMachinesListByAssessment_564224;
          assessmentName: string; subscriptionId: string; resourceGroupName: string;
          projectName: string; groupName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## assessedMachinesListByAssessment
  ## Get list of machines that assessed as part of the specified assessment. Returns a json array of objects of type 'assessedMachine' as specified in the Models section.
  ## 
  ## Whenever an assessment is created or updated, it goes under computation. During this phase, the 'status' field of Assessment object reports 'Computing'.
  ## During the period when the assessment is under computation, the list of assessed machines is empty and no assessed machines are returned by this call.
  ## 
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  var path_564236 = newJObject()
  var query_564237 = newJObject()
  add(path_564236, "assessmentName", newJString(assessmentName))
  add(query_564237, "api-version", newJString(apiVersion))
  add(path_564236, "subscriptionId", newJString(subscriptionId))
  add(path_564236, "resourceGroupName", newJString(resourceGroupName))
  add(path_564236, "projectName", newJString(projectName))
  add(path_564236, "groupName", newJString(groupName))
  result = call_564235.call(path_564236, query_564237, nil, nil, nil)

var assessedMachinesListByAssessment* = Call_AssessedMachinesListByAssessment_564224(
    name: "assessedMachinesListByAssessment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}/assessedMachines",
    validator: validate_AssessedMachinesListByAssessment_564225, base: "",
    url: url_AssessedMachinesListByAssessment_564226, schemes: {Scheme.Https})
type
  Call_AssessedMachinesGet_564238 = ref object of OpenApiRestCall_563557
proc url_AssessedMachinesGet_564240(protocol: Scheme; host: string; base: string;
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

proc validate_AssessedMachinesGet_564239(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get an assessed machine with its size & cost estimate that was evaluated in the specified assessment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessedMachineName: JString (required)
  ##                      : Unique name of an assessed machine evaluated as part of an assessment.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `assessmentName` field"
  var valid_564241 = path.getOrDefault("assessmentName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "assessmentName", valid_564241
  var valid_564242 = path.getOrDefault("subscriptionId")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "subscriptionId", valid_564242
  var valid_564243 = path.getOrDefault("resourceGroupName")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "resourceGroupName", valid_564243
  var valid_564244 = path.getOrDefault("projectName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "projectName", valid_564244
  var valid_564245 = path.getOrDefault("assessedMachineName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "assessedMachineName", valid_564245
  var valid_564246 = path.getOrDefault("groupName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "groupName", valid_564246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564247 = query.getOrDefault("api-version")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564247 != nil:
    section.add "api-version", valid_564247
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564248 = header.getOrDefault("Accept-Language")
  valid_564248 = validateParameter(valid_564248, JString, required = false,
                                 default = nil)
  if valid_564248 != nil:
    section.add "Accept-Language", valid_564248
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564249: Call_AssessedMachinesGet_564238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an assessed machine with its size & cost estimate that was evaluated in the specified assessment.
  ## 
  let valid = call_564249.validator(path, query, header, formData, body)
  let scheme = call_564249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564249.url(scheme.get, call_564249.host, call_564249.base,
                         call_564249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564249, url, valid)

proc call*(call_564250: Call_AssessedMachinesGet_564238; assessmentName: string;
          subscriptionId: string; resourceGroupName: string; projectName: string;
          assessedMachineName: string; groupName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## assessedMachinesGet
  ## Get an assessed machine with its size & cost estimate that was evaluated in the specified assessment.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessedMachineName: string (required)
  ##                      : Unique name of an assessed machine evaluated as part of an assessment.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  var path_564251 = newJObject()
  var query_564252 = newJObject()
  add(path_564251, "assessmentName", newJString(assessmentName))
  add(query_564252, "api-version", newJString(apiVersion))
  add(path_564251, "subscriptionId", newJString(subscriptionId))
  add(path_564251, "resourceGroupName", newJString(resourceGroupName))
  add(path_564251, "projectName", newJString(projectName))
  add(path_564251, "assessedMachineName", newJString(assessedMachineName))
  add(path_564251, "groupName", newJString(groupName))
  result = call_564250.call(path_564251, query_564252, nil, nil, nil)

var assessedMachinesGet* = Call_AssessedMachinesGet_564238(
    name: "assessedMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}/assessedMachines/{assessedMachineName}",
    validator: validate_AssessedMachinesGet_564239, base: "",
    url: url_AssessedMachinesGet_564240, schemes: {Scheme.Https})
type
  Call_AssessmentsGetReportDownloadUrl_564253 = ref object of OpenApiRestCall_563557
proc url_AssessmentsGetReportDownloadUrl_564255(protocol: Scheme; host: string;
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

proc validate_AssessmentsGetReportDownloadUrl_564254(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the URL for downloading the assessment in a report format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `assessmentName` field"
  var valid_564256 = path.getOrDefault("assessmentName")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "assessmentName", valid_564256
  var valid_564257 = path.getOrDefault("subscriptionId")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "subscriptionId", valid_564257
  var valid_564258 = path.getOrDefault("resourceGroupName")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "resourceGroupName", valid_564258
  var valid_564259 = path.getOrDefault("projectName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "projectName", valid_564259
  var valid_564260 = path.getOrDefault("groupName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "groupName", valid_564260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564261 = query.getOrDefault("api-version")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564261 != nil:
    section.add "api-version", valid_564261
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564262 = header.getOrDefault("Accept-Language")
  valid_564262 = validateParameter(valid_564262, JString, required = false,
                                 default = nil)
  if valid_564262 != nil:
    section.add "Accept-Language", valid_564262
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564263: Call_AssessmentsGetReportDownloadUrl_564253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the URL for downloading the assessment in a report format.
  ## 
  let valid = call_564263.validator(path, query, header, formData, body)
  let scheme = call_564263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564263.url(scheme.get, call_564263.host, call_564263.base,
                         call_564263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564263, url, valid)

proc call*(call_564264: Call_AssessmentsGetReportDownloadUrl_564253;
          assessmentName: string; subscriptionId: string; resourceGroupName: string;
          projectName: string; groupName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## assessmentsGetReportDownloadUrl
  ## Get the URL for downloading the assessment in a report format.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  var path_564265 = newJObject()
  var query_564266 = newJObject()
  add(path_564265, "assessmentName", newJString(assessmentName))
  add(query_564266, "api-version", newJString(apiVersion))
  add(path_564265, "subscriptionId", newJString(subscriptionId))
  add(path_564265, "resourceGroupName", newJString(resourceGroupName))
  add(path_564265, "projectName", newJString(projectName))
  add(path_564265, "groupName", newJString(groupName))
  result = call_564264.call(path_564265, query_564266, nil, nil, nil)

var assessmentsGetReportDownloadUrl* = Call_AssessmentsGetReportDownloadUrl_564253(
    name: "assessmentsGetReportDownloadUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}/downloadUrl",
    validator: validate_AssessmentsGetReportDownloadUrl_564254, base: "",
    url: url_AssessmentsGetReportDownloadUrl_564255, schemes: {Scheme.Https})
type
  Call_MachinesListByProject_564267 = ref object of OpenApiRestCall_563557
proc url_MachinesListByProject_564269(protocol: Scheme; host: string; base: string;
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

proc validate_MachinesListByProject_564268(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get data of all the machines available in the project. Returns a json array of objects of type 'machine' defined in Models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564270 = path.getOrDefault("subscriptionId")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "subscriptionId", valid_564270
  var valid_564271 = path.getOrDefault("resourceGroupName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "resourceGroupName", valid_564271
  var valid_564272 = path.getOrDefault("projectName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "projectName", valid_564272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564273 = query.getOrDefault("api-version")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564273 != nil:
    section.add "api-version", valid_564273
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564274 = header.getOrDefault("Accept-Language")
  valid_564274 = validateParameter(valid_564274, JString, required = false,
                                 default = nil)
  if valid_564274 != nil:
    section.add "Accept-Language", valid_564274
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564275: Call_MachinesListByProject_564267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get data of all the machines available in the project. Returns a json array of objects of type 'machine' defined in Models section.
  ## 
  let valid = call_564275.validator(path, query, header, formData, body)
  let scheme = call_564275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564275.url(scheme.get, call_564275.host, call_564275.base,
                         call_564275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564275, url, valid)

proc call*(call_564276: Call_MachinesListByProject_564267; subscriptionId: string;
          resourceGroupName: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## machinesListByProject
  ## Get data of all the machines available in the project. Returns a json array of objects of type 'machine' defined in Models section.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_564277 = newJObject()
  var query_564278 = newJObject()
  add(query_564278, "api-version", newJString(apiVersion))
  add(path_564277, "subscriptionId", newJString(subscriptionId))
  add(path_564277, "resourceGroupName", newJString(resourceGroupName))
  add(path_564277, "projectName", newJString(projectName))
  result = call_564276.call(path_564277, query_564278, nil, nil, nil)

var machinesListByProject* = Call_MachinesListByProject_564267(
    name: "machinesListByProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/machines",
    validator: validate_MachinesListByProject_564268, base: "",
    url: url_MachinesListByProject_564269, schemes: {Scheme.Https})
type
  Call_MachinesGet_564279 = ref object of OpenApiRestCall_563557
proc url_MachinesGet_564281(protocol: Scheme; host: string; base: string;
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

proc validate_MachinesGet_564280(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the machine with the specified name. Returns a json object of type 'machine' defined in Models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineName: JString (required)
  ##              : Unique name of a machine in private datacenter.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineName` field"
  var valid_564282 = path.getOrDefault("machineName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "machineName", valid_564282
  var valid_564283 = path.getOrDefault("subscriptionId")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "subscriptionId", valid_564283
  var valid_564284 = path.getOrDefault("resourceGroupName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "resourceGroupName", valid_564284
  var valid_564285 = path.getOrDefault("projectName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "projectName", valid_564285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564286 = query.getOrDefault("api-version")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564286 != nil:
    section.add "api-version", valid_564286
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564287 = header.getOrDefault("Accept-Language")
  valid_564287 = validateParameter(valid_564287, JString, required = false,
                                 default = nil)
  if valid_564287 != nil:
    section.add "Accept-Language", valid_564287
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564288: Call_MachinesGet_564279; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the machine with the specified name. Returns a json object of type 'machine' defined in Models section.
  ## 
  let valid = call_564288.validator(path, query, header, formData, body)
  let scheme = call_564288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564288.url(scheme.get, call_564288.host, call_564288.base,
                         call_564288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564288, url, valid)

proc call*(call_564289: Call_MachinesGet_564279; machineName: string;
          subscriptionId: string; resourceGroupName: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## machinesGet
  ## Get the machine with the specified name. Returns a json object of type 'machine' defined in Models section.
  ##   machineName: string (required)
  ##              : Unique name of a machine in private datacenter.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_564290 = newJObject()
  var query_564291 = newJObject()
  add(path_564290, "machineName", newJString(machineName))
  add(query_564291, "api-version", newJString(apiVersion))
  add(path_564290, "subscriptionId", newJString(subscriptionId))
  add(path_564290, "resourceGroupName", newJString(resourceGroupName))
  add(path_564290, "projectName", newJString(projectName))
  result = call_564289.call(path_564290, query_564291, nil, nil, nil)

var machinesGet* = Call_MachinesGet_564279(name: "machinesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/machines/{machineName}",
                                        validator: validate_MachinesGet_564280,
                                        base: "", url: url_MachinesGet_564281,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsList_564292 = ref object of OpenApiRestCall_563557
proc url_ProjectsList_564294(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsList_564293(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the projects in the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564295 = path.getOrDefault("subscriptionId")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "subscriptionId", valid_564295
  var valid_564296 = path.getOrDefault("resourceGroupName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "resourceGroupName", valid_564296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564297 = query.getOrDefault("api-version")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564297 != nil:
    section.add "api-version", valid_564297
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564298 = header.getOrDefault("Accept-Language")
  valid_564298 = validateParameter(valid_564298, JString, required = false,
                                 default = nil)
  if valid_564298 != nil:
    section.add "Accept-Language", valid_564298
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564299: Call_ProjectsList_564292; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the projects in the resource group.
  ## 
  let valid = call_564299.validator(path, query, header, formData, body)
  let scheme = call_564299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564299.url(scheme.get, call_564299.host, call_564299.base,
                         call_564299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564299, url, valid)

proc call*(call_564300: Call_ProjectsList_564292; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2017-11-11-preview"): Recallable =
  ## projectsList
  ## Get all the projects in the resource group.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  var path_564301 = newJObject()
  var query_564302 = newJObject()
  add(query_564302, "api-version", newJString(apiVersion))
  add(path_564301, "subscriptionId", newJString(subscriptionId))
  add(path_564301, "resourceGroupName", newJString(resourceGroupName))
  result = call_564300.call(path_564301, query_564302, nil, nil, nil)

var projectsList* = Call_ProjectsList_564292(name: "projectsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects",
    validator: validate_ProjectsList_564293, base: "", url: url_ProjectsList_564294,
    schemes: {Scheme.Https})
type
  Call_ProjectsCreate_564315 = ref object of OpenApiRestCall_563557
proc url_ProjectsCreate_564317(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsCreate_564316(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create a project with specified name. If a project already exists, update it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564318 = path.getOrDefault("subscriptionId")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "subscriptionId", valid_564318
  var valid_564319 = path.getOrDefault("resourceGroupName")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "resourceGroupName", valid_564319
  var valid_564320 = path.getOrDefault("projectName")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "projectName", valid_564320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564321 = query.getOrDefault("api-version")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564321 != nil:
    section.add "api-version", valid_564321
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564322 = header.getOrDefault("Accept-Language")
  valid_564322 = validateParameter(valid_564322, JString, required = false,
                                 default = nil)
  if valid_564322 != nil:
    section.add "Accept-Language", valid_564322
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   project: JObject
  ##          : New or Updated project object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564324: Call_ProjectsCreate_564315; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a project with specified name. If a project already exists, update it.
  ## 
  let valid = call_564324.validator(path, query, header, formData, body)
  let scheme = call_564324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564324.url(scheme.get, call_564324.host, call_564324.base,
                         call_564324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564324, url, valid)

proc call*(call_564325: Call_ProjectsCreate_564315; subscriptionId: string;
          resourceGroupName: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"; project: JsonNode = nil): Recallable =
  ## projectsCreate
  ## Create a project with specified name. If a project already exists, update it.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   project: JObject
  ##          : New or Updated project object.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_564326 = newJObject()
  var query_564327 = newJObject()
  var body_564328 = newJObject()
  add(query_564327, "api-version", newJString(apiVersion))
  add(path_564326, "subscriptionId", newJString(subscriptionId))
  if project != nil:
    body_564328 = project
  add(path_564326, "resourceGroupName", newJString(resourceGroupName))
  add(path_564326, "projectName", newJString(projectName))
  result = call_564325.call(path_564326, query_564327, nil, nil, body_564328)

var projectsCreate* = Call_ProjectsCreate_564315(name: "projectsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
    validator: validate_ProjectsCreate_564316, base: "", url: url_ProjectsCreate_564317,
    schemes: {Scheme.Https})
type
  Call_ProjectsGet_564303 = ref object of OpenApiRestCall_563557
proc url_ProjectsGet_564305(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsGet_564304(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the project with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564306 = path.getOrDefault("subscriptionId")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "subscriptionId", valid_564306
  var valid_564307 = path.getOrDefault("resourceGroupName")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "resourceGroupName", valid_564307
  var valid_564308 = path.getOrDefault("projectName")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "projectName", valid_564308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564309 = query.getOrDefault("api-version")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564309 != nil:
    section.add "api-version", valid_564309
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564310 = header.getOrDefault("Accept-Language")
  valid_564310 = validateParameter(valid_564310, JString, required = false,
                                 default = nil)
  if valid_564310 != nil:
    section.add "Accept-Language", valid_564310
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564311: Call_ProjectsGet_564303; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the project with the specified name.
  ## 
  let valid = call_564311.validator(path, query, header, formData, body)
  let scheme = call_564311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564311.url(scheme.get, call_564311.host, call_564311.base,
                         call_564311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564311, url, valid)

proc call*(call_564312: Call_ProjectsGet_564303; subscriptionId: string;
          resourceGroupName: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## projectsGet
  ## Get the project with the specified name.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_564313 = newJObject()
  var query_564314 = newJObject()
  add(query_564314, "api-version", newJString(apiVersion))
  add(path_564313, "subscriptionId", newJString(subscriptionId))
  add(path_564313, "resourceGroupName", newJString(resourceGroupName))
  add(path_564313, "projectName", newJString(projectName))
  result = call_564312.call(path_564313, query_564314, nil, nil, nil)

var projectsGet* = Call_ProjectsGet_564303(name: "projectsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
                                        validator: validate_ProjectsGet_564304,
                                        base: "", url: url_ProjectsGet_564305,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsUpdate_564341 = ref object of OpenApiRestCall_563557
proc url_ProjectsUpdate_564343(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsUpdate_564342(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update a project with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564344 = path.getOrDefault("subscriptionId")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "subscriptionId", valid_564344
  var valid_564345 = path.getOrDefault("resourceGroupName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "resourceGroupName", valid_564345
  var valid_564346 = path.getOrDefault("projectName")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "projectName", valid_564346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564347 = query.getOrDefault("api-version")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564347 != nil:
    section.add "api-version", valid_564347
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564348 = header.getOrDefault("Accept-Language")
  valid_564348 = validateParameter(valid_564348, JString, required = false,
                                 default = nil)
  if valid_564348 != nil:
    section.add "Accept-Language", valid_564348
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   project: JObject
  ##          : Updated project object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564350: Call_ProjectsUpdate_564341; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a project with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  let valid = call_564350.validator(path, query, header, formData, body)
  let scheme = call_564350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564350.url(scheme.get, call_564350.host, call_564350.base,
                         call_564350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564350, url, valid)

proc call*(call_564351: Call_ProjectsUpdate_564341; subscriptionId: string;
          resourceGroupName: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"; project: JsonNode = nil): Recallable =
  ## projectsUpdate
  ## Update a project with specified name. Supports partial updates, for example only tags can be provided.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   project: JObject
  ##          : Updated project object.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_564352 = newJObject()
  var query_564353 = newJObject()
  var body_564354 = newJObject()
  add(query_564353, "api-version", newJString(apiVersion))
  add(path_564352, "subscriptionId", newJString(subscriptionId))
  if project != nil:
    body_564354 = project
  add(path_564352, "resourceGroupName", newJString(resourceGroupName))
  add(path_564352, "projectName", newJString(projectName))
  result = call_564351.call(path_564352, query_564353, nil, nil, body_564354)

var projectsUpdate* = Call_ProjectsUpdate_564341(name: "projectsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
    validator: validate_ProjectsUpdate_564342, base: "", url: url_ProjectsUpdate_564343,
    schemes: {Scheme.Https})
type
  Call_ProjectsDelete_564329 = ref object of OpenApiRestCall_563557
proc url_ProjectsDelete_564331(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsDelete_564330(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete the project. Deleting non-existent project is a no-operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564332 = path.getOrDefault("subscriptionId")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "subscriptionId", valid_564332
  var valid_564333 = path.getOrDefault("resourceGroupName")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "resourceGroupName", valid_564333
  var valid_564334 = path.getOrDefault("projectName")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "projectName", valid_564334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564335 = query.getOrDefault("api-version")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564335 != nil:
    section.add "api-version", valid_564335
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564336 = header.getOrDefault("Accept-Language")
  valid_564336 = validateParameter(valid_564336, JString, required = false,
                                 default = nil)
  if valid_564336 != nil:
    section.add "Accept-Language", valid_564336
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564337: Call_ProjectsDelete_564329; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the project. Deleting non-existent project is a no-operation.
  ## 
  let valid = call_564337.validator(path, query, header, formData, body)
  let scheme = call_564337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564337.url(scheme.get, call_564337.host, call_564337.base,
                         call_564337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564337, url, valid)

proc call*(call_564338: Call_ProjectsDelete_564329; subscriptionId: string;
          resourceGroupName: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## projectsDelete
  ## Delete the project. Deleting non-existent project is a no-operation.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_564339 = newJObject()
  var query_564340 = newJObject()
  add(query_564340, "api-version", newJString(apiVersion))
  add(path_564339, "subscriptionId", newJString(subscriptionId))
  add(path_564339, "resourceGroupName", newJString(resourceGroupName))
  add(path_564339, "projectName", newJString(projectName))
  result = call_564338.call(path_564339, query_564340, nil, nil, nil)

var projectsDelete* = Call_ProjectsDelete_564329(name: "projectsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
    validator: validate_ProjectsDelete_564330, base: "", url: url_ProjectsDelete_564331,
    schemes: {Scheme.Https})
type
  Call_ProjectsGetKeys_564355 = ref object of OpenApiRestCall_563557
proc url_ProjectsGetKeys_564357(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsGetKeys_564356(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the Log Analytics Workspace ID and Primary Key for the specified project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564358 = path.getOrDefault("subscriptionId")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "subscriptionId", valid_564358
  var valid_564359 = path.getOrDefault("resourceGroupName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "resourceGroupName", valid_564359
  var valid_564360 = path.getOrDefault("projectName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "projectName", valid_564360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564361 = query.getOrDefault("api-version")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = newJString("2017-11-11-preview"))
  if valid_564361 != nil:
    section.add "api-version", valid_564361
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564362 = header.getOrDefault("Accept-Language")
  valid_564362 = validateParameter(valid_564362, JString, required = false,
                                 default = nil)
  if valid_564362 != nil:
    section.add "Accept-Language", valid_564362
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564363: Call_ProjectsGetKeys_564355; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Log Analytics Workspace ID and Primary Key for the specified project.
  ## 
  let valid = call_564363.validator(path, query, header, formData, body)
  let scheme = call_564363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564363.url(scheme.get, call_564363.host, call_564363.base,
                         call_564363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564363, url, valid)

proc call*(call_564364: Call_ProjectsGetKeys_564355; subscriptionId: string;
          resourceGroupName: string; projectName: string;
          apiVersion: string = "2017-11-11-preview"): Recallable =
  ## projectsGetKeys
  ## Gets the Log Analytics Workspace ID and Primary Key for the specified project.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_564365 = newJObject()
  var query_564366 = newJObject()
  add(query_564366, "api-version", newJString(apiVersion))
  add(path_564365, "subscriptionId", newJString(subscriptionId))
  add(path_564365, "resourceGroupName", newJString(resourceGroupName))
  add(path_564365, "projectName", newJString(projectName))
  result = call_564364.call(path_564365, query_564366, nil, nil, nil)

var projectsGetKeys* = Call_ProjectsGetKeys_564355(name: "projectsGetKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/keys",
    validator: validate_ProjectsGetKeys_564356, base: "", url: url_ProjectsGetKeys_564357,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
