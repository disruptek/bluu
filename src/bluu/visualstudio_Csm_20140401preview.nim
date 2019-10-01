
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Visual Studio Resource Provider Client
## version: 2014-04-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these APIs to manage Visual Studio Team Services resources through the Azure Resource Manager. All task operations conform to the HTTP/1.1 protocol specification and each operation returns an x-ms-request-id header that can be used to obtain information about the request. You must make sure that requests made to these resources are secure. For more information, see https://docs.microsoft.com/en-us/rest/api/index.
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "visualstudio-Csm"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567863 = ref object of OpenApiRestCall_567641
proc url_OperationsList_567865(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567864(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the details of all operations possible on the Microsoft.VisualStudio resource provider.
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

proc call*(call_567970: Call_OperationsList_567863; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of all operations possible on the Microsoft.VisualStudio resource provider.
  ## 
  let valid = call_567970.validator(path, query, header, formData, body)
  let scheme = call_567970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_567970.url(scheme.get, call_567970.host, call_567970.base,
                         call_567970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_567970, url, valid)

proc call*(call_568054: Call_OperationsList_567863): Recallable =
  ## operationsList
  ## Gets the details of all operations possible on the Microsoft.VisualStudio resource provider.
  result = call_568054.call(nil, nil, nil, nil, nil)

var operationsList* = Call_OperationsList_567863(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/microsoft.visualstudio/operations",
    validator: validate_OperationsList_567864, base: "", url: url_OperationsList_567865,
    schemes: {Scheme.Https})
type
  Call_AccountsCheckNameAvailability_568092 = ref object of OpenApiRestCall_567641
proc url_AccountsCheckNameAvailability_568094(protocol: Scheme; host: string;
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
        value: "/providers/microsoft.visualstudio/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsCheckNameAvailability_568093(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks if the specified Visual Studio Team Services account name is available. Resource name can be either an account name or an account name and PUID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568172 = path.getOrDefault("subscriptionId")
  valid_568172 = validateParameter(valid_568172, JString, required = true,
                                 default = nil)
  if valid_568172 != nil:
    section.add "subscriptionId", valid_568172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568173 = query.getOrDefault("api-version")
  valid_568173 = validateParameter(valid_568173, JString, required = true,
                                 default = nil)
  if valid_568173 != nil:
    section.add "api-version", valid_568173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Parameters describing the name to check availability for.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568175: Call_AccountsCheckNameAvailability_568092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks if the specified Visual Studio Team Services account name is available. Resource name can be either an account name or an account name and PUID.
  ## 
  let valid = call_568175.validator(path, query, header, formData, body)
  let scheme = call_568175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568175.url(scheme.get, call_568175.host, call_568175.base,
                         call_568175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568175, url, valid)

proc call*(call_568176: Call_AccountsCheckNameAvailability_568092;
          apiVersion: string; subscriptionId: string; body: JsonNode): Recallable =
  ## accountsCheckNameAvailability
  ## Checks if the specified Visual Studio Team Services account name is available. Resource name can be either an account name or an account name and PUID.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   body: JObject (required)
  ##       : Parameters describing the name to check availability for.
  var path_568177 = newJObject()
  var query_568179 = newJObject()
  var body_568180 = newJObject()
  add(query_568179, "api-version", newJString(apiVersion))
  add(path_568177, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_568180 = body
  result = call_568176.call(path_568177, query_568179, nil, nil, body_568180)

var accountsCheckNameAvailability* = Call_AccountsCheckNameAvailability_568092(
    name: "accountsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/microsoft.visualstudio/checkNameAvailability",
    validator: validate_AccountsCheckNameAvailability_568093, base: "",
    url: url_AccountsCheckNameAvailability_568094, schemes: {Scheme.Https})
type
  Call_ProjectsListByResourceGroup_568182 = ref object of OpenApiRestCall_567641
proc url_ProjectsListByResourceGroup_568184(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "rootResourceName" in path,
        "`rootResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.visualstudio/account/"),
               (kind: VariableSegment, value: "rootResourceName"),
               (kind: ConstantSegment, value: "/project")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsListByResourceGroup_568183(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all Visual Studio Team Services project resources created in the specified Team Services account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   rootResourceName: JString (required)
  ##                   : Name of the Team Services account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568185 = path.getOrDefault("resourceGroupName")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "resourceGroupName", valid_568185
  var valid_568186 = path.getOrDefault("subscriptionId")
  valid_568186 = validateParameter(valid_568186, JString, required = true,
                                 default = nil)
  if valid_568186 != nil:
    section.add "subscriptionId", valid_568186
  var valid_568187 = path.getOrDefault("rootResourceName")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "rootResourceName", valid_568187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568188 = query.getOrDefault("api-version")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "api-version", valid_568188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568189: Call_ProjectsListByResourceGroup_568182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Visual Studio Team Services project resources created in the specified Team Services account.
  ## 
  let valid = call_568189.validator(path, query, header, formData, body)
  let scheme = call_568189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568189.url(scheme.get, call_568189.host, call_568189.base,
                         call_568189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568189, url, valid)

proc call*(call_568190: Call_ProjectsListByResourceGroup_568182;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          rootResourceName: string): Recallable =
  ## projectsListByResourceGroup
  ## Gets all Visual Studio Team Services project resources created in the specified Team Services account.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   rootResourceName: string (required)
  ##                   : Name of the Team Services account.
  var path_568191 = newJObject()
  var query_568192 = newJObject()
  add(path_568191, "resourceGroupName", newJString(resourceGroupName))
  add(query_568192, "api-version", newJString(apiVersion))
  add(path_568191, "subscriptionId", newJString(subscriptionId))
  add(path_568191, "rootResourceName", newJString(rootResourceName))
  result = call_568190.call(path_568191, query_568192, nil, nil, nil)

var projectsListByResourceGroup* = Call_ProjectsListByResourceGroup_568182(
    name: "projectsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project",
    validator: validate_ProjectsListByResourceGroup_568183, base: "",
    url: url_ProjectsListByResourceGroup_568184, schemes: {Scheme.Https})
type
  Call_ProjectsCreate_568205 = ref object of OpenApiRestCall_567641
proc url_ProjectsCreate_568207(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "rootResourceName" in path,
        "`rootResourceName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.visualstudio/account/"),
               (kind: VariableSegment, value: "rootResourceName"),
               (kind: ConstantSegment, value: "/project/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsCreate_568206(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates a Team Services project in the collection with the specified name. 'VersionControlOption' and 'ProcessTemplateId' must be specified in the resource properties. Valid values for VersionControlOption: Git, Tfvc. Valid values for ProcessTemplateId: 6B724908-EF14-45CF-84F8-768B5384DA45, ADCC42AB-9882-485E-A3ED-7678F01F66BC, 27450541-8E31-4150-9947-DC59F998FC01 (these IDs correspond to Scrum, Agile, and CMMI process templates).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   resourceName: JString (required)
  ##               : Name of the Team Services project.
  ##   rootResourceName: JString (required)
  ##                   : Name of the Team Services account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568208 = path.getOrDefault("resourceGroupName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "resourceGroupName", valid_568208
  var valid_568209 = path.getOrDefault("subscriptionId")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "subscriptionId", valid_568209
  var valid_568210 = path.getOrDefault("resourceName")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "resourceName", valid_568210
  var valid_568211 = path.getOrDefault("rootResourceName")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "rootResourceName", valid_568211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   validating: JString
  ##             : This parameter is ignored and should be set to an empty string.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568212 = query.getOrDefault("api-version")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "api-version", valid_568212
  var valid_568213 = query.getOrDefault("validating")
  valid_568213 = validateParameter(valid_568213, JString, required = false,
                                 default = nil)
  if valid_568213 != nil:
    section.add "validating", valid_568213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The request data.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568215: Call_ProjectsCreate_568205; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Team Services project in the collection with the specified name. 'VersionControlOption' and 'ProcessTemplateId' must be specified in the resource properties. Valid values for VersionControlOption: Git, Tfvc. Valid values for ProcessTemplateId: 6B724908-EF14-45CF-84F8-768B5384DA45, ADCC42AB-9882-485E-A3ED-7678F01F66BC, 27450541-8E31-4150-9947-DC59F998FC01 (these IDs correspond to Scrum, Agile, and CMMI process templates).
  ## 
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_ProjectsCreate_568205; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          body: JsonNode; rootResourceName: string; validating: string = ""): Recallable =
  ## projectsCreate
  ## Creates a Team Services project in the collection with the specified name. 'VersionControlOption' and 'ProcessTemplateId' must be specified in the resource properties. Valid values for VersionControlOption: Git, Tfvc. Valid values for ProcessTemplateId: 6B724908-EF14-45CF-84F8-768B5384DA45, ADCC42AB-9882-485E-A3ED-7678F01F66BC, 27450541-8E31-4150-9947-DC59F998FC01 (these IDs correspond to Scrum, Agile, and CMMI process templates).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   resourceName: string (required)
  ##               : Name of the Team Services project.
  ##   validating: string
  ##             : This parameter is ignored and should be set to an empty string.
  ##   body: JObject (required)
  ##       : The request data.
  ##   rootResourceName: string (required)
  ##                   : Name of the Team Services account.
  var path_568217 = newJObject()
  var query_568218 = newJObject()
  var body_568219 = newJObject()
  add(path_568217, "resourceGroupName", newJString(resourceGroupName))
  add(query_568218, "api-version", newJString(apiVersion))
  add(path_568217, "subscriptionId", newJString(subscriptionId))
  add(path_568217, "resourceName", newJString(resourceName))
  add(query_568218, "validating", newJString(validating))
  if body != nil:
    body_568219 = body
  add(path_568217, "rootResourceName", newJString(rootResourceName))
  result = call_568216.call(path_568217, query_568218, nil, nil, body_568219)

var projectsCreate* = Call_ProjectsCreate_568205(name: "projectsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project/{resourceName}",
    validator: validate_ProjectsCreate_568206, base: "", url: url_ProjectsCreate_568207,
    schemes: {Scheme.Https})
type
  Call_ProjectsGet_568193 = ref object of OpenApiRestCall_567641
proc url_ProjectsGet_568195(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "rootResourceName" in path,
        "`rootResourceName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.visualstudio/account/"),
               (kind: VariableSegment, value: "rootResourceName"),
               (kind: ConstantSegment, value: "/project/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsGet_568194(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a Team Services project resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   resourceName: JString (required)
  ##               : Name of the Team Services project.
  ##   rootResourceName: JString (required)
  ##                   : Name of the Team Services account.
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
  var valid_568198 = path.getOrDefault("resourceName")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "resourceName", valid_568198
  var valid_568199 = path.getOrDefault("rootResourceName")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "rootResourceName", valid_568199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568200 = query.getOrDefault("api-version")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "api-version", valid_568200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568201: Call_ProjectsGet_568193; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a Team Services project resource.
  ## 
  let valid = call_568201.validator(path, query, header, formData, body)
  let scheme = call_568201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568201.url(scheme.get, call_568201.host, call_568201.base,
                         call_568201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568201, url, valid)

proc call*(call_568202: Call_ProjectsGet_568193; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          rootResourceName: string): Recallable =
  ## projectsGet
  ## Gets the details of a Team Services project resource.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   resourceName: string (required)
  ##               : Name of the Team Services project.
  ##   rootResourceName: string (required)
  ##                   : Name of the Team Services account.
  var path_568203 = newJObject()
  var query_568204 = newJObject()
  add(path_568203, "resourceGroupName", newJString(resourceGroupName))
  add(query_568204, "api-version", newJString(apiVersion))
  add(path_568203, "subscriptionId", newJString(subscriptionId))
  add(path_568203, "resourceName", newJString(resourceName))
  add(path_568203, "rootResourceName", newJString(rootResourceName))
  result = call_568202.call(path_568203, query_568204, nil, nil, nil)

var projectsGet* = Call_ProjectsGet_568193(name: "projectsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project/{resourceName}",
                                        validator: validate_ProjectsGet_568194,
                                        base: "", url: url_ProjectsGet_568195,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsUpdate_568220 = ref object of OpenApiRestCall_567641
proc url_ProjectsUpdate_568222(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "rootResourceName" in path,
        "`rootResourceName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.visualstudio/account/"),
               (kind: VariableSegment, value: "rootResourceName"),
               (kind: ConstantSegment, value: "/project/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsUpdate_568221(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates the tags of the specified Team Services project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   resourceName: JString (required)
  ##               : Name of the Team Services project.
  ##   rootResourceName: JString (required)
  ##                   : Name of the Team Services account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568223 = path.getOrDefault("resourceGroupName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "resourceGroupName", valid_568223
  var valid_568224 = path.getOrDefault("subscriptionId")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "subscriptionId", valid_568224
  var valid_568225 = path.getOrDefault("resourceName")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "resourceName", valid_568225
  var valid_568226 = path.getOrDefault("rootResourceName")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "rootResourceName", valid_568226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568227 = query.getOrDefault("api-version")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "api-version", valid_568227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The request data.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568229: Call_ProjectsUpdate_568220; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tags of the specified Team Services project.
  ## 
  let valid = call_568229.validator(path, query, header, formData, body)
  let scheme = call_568229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568229.url(scheme.get, call_568229.host, call_568229.base,
                         call_568229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568229, url, valid)

proc call*(call_568230: Call_ProjectsUpdate_568220; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          body: JsonNode; rootResourceName: string): Recallable =
  ## projectsUpdate
  ## Updates the tags of the specified Team Services project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   resourceName: string (required)
  ##               : Name of the Team Services project.
  ##   body: JObject (required)
  ##       : The request data.
  ##   rootResourceName: string (required)
  ##                   : Name of the Team Services account.
  var path_568231 = newJObject()
  var query_568232 = newJObject()
  var body_568233 = newJObject()
  add(path_568231, "resourceGroupName", newJString(resourceGroupName))
  add(query_568232, "api-version", newJString(apiVersion))
  add(path_568231, "subscriptionId", newJString(subscriptionId))
  add(path_568231, "resourceName", newJString(resourceName))
  if body != nil:
    body_568233 = body
  add(path_568231, "rootResourceName", newJString(rootResourceName))
  result = call_568230.call(path_568231, query_568232, nil, nil, body_568233)

var projectsUpdate* = Call_ProjectsUpdate_568220(name: "projectsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project/{resourceName}",
    validator: validate_ProjectsUpdate_568221, base: "", url: url_ProjectsUpdate_568222,
    schemes: {Scheme.Https})
type
  Call_ProjectsGetJobStatus_568234 = ref object of OpenApiRestCall_567641
proc url_ProjectsGetJobStatus_568236(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "rootResourceName" in path,
        "`rootResourceName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "subContainerName" in path,
        "`subContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.visualstudio/account/"),
               (kind: VariableSegment, value: "rootResourceName"),
               (kind: ConstantSegment, value: "/project/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/subContainers/"),
               (kind: VariableSegment, value: "subContainerName"),
               (kind: ConstantSegment, value: "/status")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsGetJobStatus_568235(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of the project resource creation job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   resourceName: JString (required)
  ##               : Name of the Team Services project.
  ##   subContainerName: JString (required)
  ##                   : This parameter should be set to the resourceName.
  ##   rootResourceName: JString (required)
  ##                   : Name of the Team Services account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568237 = path.getOrDefault("resourceGroupName")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "resourceGroupName", valid_568237
  var valid_568238 = path.getOrDefault("subscriptionId")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "subscriptionId", valid_568238
  var valid_568239 = path.getOrDefault("resourceName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "resourceName", valid_568239
  var valid_568240 = path.getOrDefault("subContainerName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "subContainerName", valid_568240
  var valid_568241 = path.getOrDefault("rootResourceName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "rootResourceName", valid_568241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   jobId: JString
  ##        : The job identifier.
  ##   operation: JString (required)
  ##            : The operation type. The only supported value is 'put'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568242 = query.getOrDefault("api-version")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "api-version", valid_568242
  var valid_568243 = query.getOrDefault("jobId")
  valid_568243 = validateParameter(valid_568243, JString, required = false,
                                 default = nil)
  if valid_568243 != nil:
    section.add "jobId", valid_568243
  var valid_568244 = query.getOrDefault("operation")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "operation", valid_568244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568245: Call_ProjectsGetJobStatus_568234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of the project resource creation job.
  ## 
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_ProjectsGetJobStatus_568234;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; subContainerName: string; operation: string;
          rootResourceName: string; jobId: string = ""): Recallable =
  ## projectsGetJobStatus
  ## Gets the status of the project resource creation job.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   jobId: string
  ##        : The job identifier.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   resourceName: string (required)
  ##               : Name of the Team Services project.
  ##   subContainerName: string (required)
  ##                   : This parameter should be set to the resourceName.
  ##   operation: string (required)
  ##            : The operation type. The only supported value is 'put'.
  ##   rootResourceName: string (required)
  ##                   : Name of the Team Services account.
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  add(path_568247, "resourceGroupName", newJString(resourceGroupName))
  add(query_568248, "api-version", newJString(apiVersion))
  add(query_568248, "jobId", newJString(jobId))
  add(path_568247, "subscriptionId", newJString(subscriptionId))
  add(path_568247, "resourceName", newJString(resourceName))
  add(path_568247, "subContainerName", newJString(subContainerName))
  add(query_568248, "operation", newJString(operation))
  add(path_568247, "rootResourceName", newJString(rootResourceName))
  result = call_568246.call(path_568247, query_568248, nil, nil, nil)

var projectsGetJobStatus* = Call_ProjectsGetJobStatus_568234(
    name: "projectsGetJobStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project/{resourceName}/subContainers/{subContainerName}/status",
    validator: validate_ProjectsGetJobStatus_568235, base: "",
    url: url_ProjectsGetJobStatus_568236, schemes: {Scheme.Https})
type
  Call_AccountsListByResourceGroup_568249 = ref object of OpenApiRestCall_567641
proc url_AccountsListByResourceGroup_568251(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/microsoft.visualstudio/account")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsListByResourceGroup_568250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all Visual Studio Team Services account resources under the resource group linked to the specified Azure subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568252 = path.getOrDefault("resourceGroupName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "resourceGroupName", valid_568252
  var valid_568253 = path.getOrDefault("subscriptionId")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "subscriptionId", valid_568253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568254 = query.getOrDefault("api-version")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "api-version", valid_568254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568255: Call_AccountsListByResourceGroup_568249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Visual Studio Team Services account resources under the resource group linked to the specified Azure subscription.
  ## 
  let valid = call_568255.validator(path, query, header, formData, body)
  let scheme = call_568255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568255.url(scheme.get, call_568255.host, call_568255.base,
                         call_568255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568255, url, valid)

proc call*(call_568256: Call_AccountsListByResourceGroup_568249;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## accountsListByResourceGroup
  ## Gets all Visual Studio Team Services account resources under the resource group linked to the specified Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  var path_568257 = newJObject()
  var query_568258 = newJObject()
  add(path_568257, "resourceGroupName", newJString(resourceGroupName))
  add(query_568258, "api-version", newJString(apiVersion))
  add(path_568257, "subscriptionId", newJString(subscriptionId))
  result = call_568256.call(path_568257, query_568258, nil, nil, nil)

var accountsListByResourceGroup* = Call_AccountsListByResourceGroup_568249(
    name: "accountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account",
    validator: validate_AccountsListByResourceGroup_568250, base: "",
    url: url_AccountsListByResourceGroup_568251, schemes: {Scheme.Https})
type
  Call_ExtensionsListByAccount_568259 = ref object of OpenApiRestCall_567641
proc url_ExtensionsListByAccount_568261(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountResourceName" in path,
        "`accountResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.visualstudio/account/"),
               (kind: VariableSegment, value: "accountResourceName"),
               (kind: ConstantSegment, value: "/extension")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExtensionsListByAccount_568260(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the extension resources created within the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   accountResourceName: JString (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568262 = path.getOrDefault("resourceGroupName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "resourceGroupName", valid_568262
  var valid_568263 = path.getOrDefault("subscriptionId")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "subscriptionId", valid_568263
  var valid_568264 = path.getOrDefault("accountResourceName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "accountResourceName", valid_568264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568265 = query.getOrDefault("api-version")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "api-version", valid_568265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568266: Call_ExtensionsListByAccount_568259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the extension resources created within the resource group.
  ## 
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_ExtensionsListByAccount_568259;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountResourceName: string): Recallable =
  ## extensionsListByAccount
  ## Gets the details of the extension resources created within the resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   accountResourceName: string (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  var path_568268 = newJObject()
  var query_568269 = newJObject()
  add(path_568268, "resourceGroupName", newJString(resourceGroupName))
  add(query_568269, "api-version", newJString(apiVersion))
  add(path_568268, "subscriptionId", newJString(subscriptionId))
  add(path_568268, "accountResourceName", newJString(accountResourceName))
  result = call_568267.call(path_568268, query_568269, nil, nil, nil)

var extensionsListByAccount* = Call_ExtensionsListByAccount_568259(
    name: "extensionsListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension",
    validator: validate_ExtensionsListByAccount_568260, base: "",
    url: url_ExtensionsListByAccount_568261, schemes: {Scheme.Https})
type
  Call_ExtensionsCreate_568282 = ref object of OpenApiRestCall_567641
proc url_ExtensionsCreate_568284(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountResourceName" in path,
        "`accountResourceName` is a required path parameter"
  assert "extensionResourceName" in path,
        "`extensionResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.visualstudio/account/"),
               (kind: VariableSegment, value: "accountResourceName"),
               (kind: ConstantSegment, value: "/extension/"),
               (kind: VariableSegment, value: "extensionResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExtensionsCreate_568283(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Registers the extension with a Visual Studio Team Services account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   extensionResourceName: JString (required)
  ##                        : The name of the extension.
  ##   accountResourceName: JString (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568285 = path.getOrDefault("resourceGroupName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "resourceGroupName", valid_568285
  var valid_568286 = path.getOrDefault("subscriptionId")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "subscriptionId", valid_568286
  var valid_568287 = path.getOrDefault("extensionResourceName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "extensionResourceName", valid_568287
  var valid_568288 = path.getOrDefault("accountResourceName")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "accountResourceName", valid_568288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568289 = query.getOrDefault("api-version")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "api-version", valid_568289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : An object containing additional information related to the extension request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568291: Call_ExtensionsCreate_568282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers the extension with a Visual Studio Team Services account.
  ## 
  let valid = call_568291.validator(path, query, header, formData, body)
  let scheme = call_568291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568291.url(scheme.get, call_568291.host, call_568291.base,
                         call_568291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568291, url, valid)

proc call*(call_568292: Call_ExtensionsCreate_568282; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; extensionResourceName: string;
          accountResourceName: string; body: JsonNode): Recallable =
  ## extensionsCreate
  ## Registers the extension with a Visual Studio Team Services account.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   extensionResourceName: string (required)
  ##                        : The name of the extension.
  ##   accountResourceName: string (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  ##   body: JObject (required)
  ##       : An object containing additional information related to the extension request.
  var path_568293 = newJObject()
  var query_568294 = newJObject()
  var body_568295 = newJObject()
  add(path_568293, "resourceGroupName", newJString(resourceGroupName))
  add(query_568294, "api-version", newJString(apiVersion))
  add(path_568293, "subscriptionId", newJString(subscriptionId))
  add(path_568293, "extensionResourceName", newJString(extensionResourceName))
  add(path_568293, "accountResourceName", newJString(accountResourceName))
  if body != nil:
    body_568295 = body
  result = call_568292.call(path_568293, query_568294, nil, nil, body_568295)

var extensionsCreate* = Call_ExtensionsCreate_568282(name: "extensionsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension/{extensionResourceName}",
    validator: validate_ExtensionsCreate_568283, base: "",
    url: url_ExtensionsCreate_568284, schemes: {Scheme.Https})
type
  Call_ExtensionsGet_568270 = ref object of OpenApiRestCall_567641
proc url_ExtensionsGet_568272(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountResourceName" in path,
        "`accountResourceName` is a required path parameter"
  assert "extensionResourceName" in path,
        "`extensionResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.visualstudio/account/"),
               (kind: VariableSegment, value: "accountResourceName"),
               (kind: ConstantSegment, value: "/extension/"),
               (kind: VariableSegment, value: "extensionResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExtensionsGet_568271(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of an extension associated with a Visual Studio Team Services account resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   extensionResourceName: JString (required)
  ##                        : The name of the extension.
  ##   accountResourceName: JString (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568273 = path.getOrDefault("resourceGroupName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "resourceGroupName", valid_568273
  var valid_568274 = path.getOrDefault("subscriptionId")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "subscriptionId", valid_568274
  var valid_568275 = path.getOrDefault("extensionResourceName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "extensionResourceName", valid_568275
  var valid_568276 = path.getOrDefault("accountResourceName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "accountResourceName", valid_568276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568277 = query.getOrDefault("api-version")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "api-version", valid_568277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568278: Call_ExtensionsGet_568270; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an extension associated with a Visual Studio Team Services account resource.
  ## 
  let valid = call_568278.validator(path, query, header, formData, body)
  let scheme = call_568278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568278.url(scheme.get, call_568278.host, call_568278.base,
                         call_568278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568278, url, valid)

proc call*(call_568279: Call_ExtensionsGet_568270; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; extensionResourceName: string;
          accountResourceName: string): Recallable =
  ## extensionsGet
  ## Gets the details of an extension associated with a Visual Studio Team Services account resource.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   extensionResourceName: string (required)
  ##                        : The name of the extension.
  ##   accountResourceName: string (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  var path_568280 = newJObject()
  var query_568281 = newJObject()
  add(path_568280, "resourceGroupName", newJString(resourceGroupName))
  add(query_568281, "api-version", newJString(apiVersion))
  add(path_568280, "subscriptionId", newJString(subscriptionId))
  add(path_568280, "extensionResourceName", newJString(extensionResourceName))
  add(path_568280, "accountResourceName", newJString(accountResourceName))
  result = call_568279.call(path_568280, query_568281, nil, nil, nil)

var extensionsGet* = Call_ExtensionsGet_568270(name: "extensionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension/{extensionResourceName}",
    validator: validate_ExtensionsGet_568271, base: "", url: url_ExtensionsGet_568272,
    schemes: {Scheme.Https})
type
  Call_ExtensionsUpdate_568308 = ref object of OpenApiRestCall_567641
proc url_ExtensionsUpdate_568310(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountResourceName" in path,
        "`accountResourceName` is a required path parameter"
  assert "extensionResourceName" in path,
        "`extensionResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.visualstudio/account/"),
               (kind: VariableSegment, value: "accountResourceName"),
               (kind: ConstantSegment, value: "/extension/"),
               (kind: VariableSegment, value: "extensionResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExtensionsUpdate_568309(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates an existing extension registration for the Visual Studio Team Services account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   extensionResourceName: JString (required)
  ##                        : The name of the extension.
  ##   accountResourceName: JString (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568311 = path.getOrDefault("resourceGroupName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "resourceGroupName", valid_568311
  var valid_568312 = path.getOrDefault("subscriptionId")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "subscriptionId", valid_568312
  var valid_568313 = path.getOrDefault("extensionResourceName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "extensionResourceName", valid_568313
  var valid_568314 = path.getOrDefault("accountResourceName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "accountResourceName", valid_568314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568315 = query.getOrDefault("api-version")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "api-version", valid_568315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : An object containing additional information related to the extension request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568317: Call_ExtensionsUpdate_568308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing extension registration for the Visual Studio Team Services account.
  ## 
  let valid = call_568317.validator(path, query, header, formData, body)
  let scheme = call_568317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568317.url(scheme.get, call_568317.host, call_568317.base,
                         call_568317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568317, url, valid)

proc call*(call_568318: Call_ExtensionsUpdate_568308; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; extensionResourceName: string;
          accountResourceName: string; body: JsonNode): Recallable =
  ## extensionsUpdate
  ## Updates an existing extension registration for the Visual Studio Team Services account.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   extensionResourceName: string (required)
  ##                        : The name of the extension.
  ##   accountResourceName: string (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  ##   body: JObject (required)
  ##       : An object containing additional information related to the extension request.
  var path_568319 = newJObject()
  var query_568320 = newJObject()
  var body_568321 = newJObject()
  add(path_568319, "resourceGroupName", newJString(resourceGroupName))
  add(query_568320, "api-version", newJString(apiVersion))
  add(path_568319, "subscriptionId", newJString(subscriptionId))
  add(path_568319, "extensionResourceName", newJString(extensionResourceName))
  add(path_568319, "accountResourceName", newJString(accountResourceName))
  if body != nil:
    body_568321 = body
  result = call_568318.call(path_568319, query_568320, nil, nil, body_568321)

var extensionsUpdate* = Call_ExtensionsUpdate_568308(name: "extensionsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension/{extensionResourceName}",
    validator: validate_ExtensionsUpdate_568309, base: "",
    url: url_ExtensionsUpdate_568310, schemes: {Scheme.Https})
type
  Call_ExtensionsDelete_568296 = ref object of OpenApiRestCall_567641
proc url_ExtensionsDelete_568298(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountResourceName" in path,
        "`accountResourceName` is a required path parameter"
  assert "extensionResourceName" in path,
        "`extensionResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.visualstudio/account/"),
               (kind: VariableSegment, value: "accountResourceName"),
               (kind: ConstantSegment, value: "/extension/"),
               (kind: VariableSegment, value: "extensionResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExtensionsDelete_568297(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Removes an extension resource registration for a Visual Studio Team Services account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   extensionResourceName: JString (required)
  ##                        : The name of the extension.
  ##   accountResourceName: JString (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568299 = path.getOrDefault("resourceGroupName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "resourceGroupName", valid_568299
  var valid_568300 = path.getOrDefault("subscriptionId")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "subscriptionId", valid_568300
  var valid_568301 = path.getOrDefault("extensionResourceName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "extensionResourceName", valid_568301
  var valid_568302 = path.getOrDefault("accountResourceName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "accountResourceName", valid_568302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568303 = query.getOrDefault("api-version")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "api-version", valid_568303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568304: Call_ExtensionsDelete_568296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes an extension resource registration for a Visual Studio Team Services account.
  ## 
  let valid = call_568304.validator(path, query, header, formData, body)
  let scheme = call_568304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568304.url(scheme.get, call_568304.host, call_568304.base,
                         call_568304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568304, url, valid)

proc call*(call_568305: Call_ExtensionsDelete_568296; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; extensionResourceName: string;
          accountResourceName: string): Recallable =
  ## extensionsDelete
  ## Removes an extension resource registration for a Visual Studio Team Services account.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   extensionResourceName: string (required)
  ##                        : The name of the extension.
  ##   accountResourceName: string (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  var path_568306 = newJObject()
  var query_568307 = newJObject()
  add(path_568306, "resourceGroupName", newJString(resourceGroupName))
  add(query_568307, "api-version", newJString(apiVersion))
  add(path_568306, "subscriptionId", newJString(subscriptionId))
  add(path_568306, "extensionResourceName", newJString(extensionResourceName))
  add(path_568306, "accountResourceName", newJString(accountResourceName))
  result = call_568305.call(path_568306, query_568307, nil, nil, nil)

var extensionsDelete* = Call_ExtensionsDelete_568296(name: "extensionsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension/{extensionResourceName}",
    validator: validate_ExtensionsDelete_568297, base: "",
    url: url_ExtensionsDelete_568298, schemes: {Scheme.Https})
type
  Call_AccountsCreateOrUpdate_568333 = ref object of OpenApiRestCall_567641
proc url_AccountsCreateOrUpdate_568335(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.visualstudio/account/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsCreateOrUpdate_568334(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Visual Studio Team Services account resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568336 = path.getOrDefault("resourceGroupName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "resourceGroupName", valid_568336
  var valid_568337 = path.getOrDefault("subscriptionId")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "subscriptionId", valid_568337
  var valid_568338 = path.getOrDefault("resourceName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "resourceName", valid_568338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568339 = query.getOrDefault("api-version")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "api-version", valid_568339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The request data.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568341: Call_AccountsCreateOrUpdate_568333; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Visual Studio Team Services account resource.
  ## 
  let valid = call_568341.validator(path, query, header, formData, body)
  let scheme = call_568341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568341.url(scheme.get, call_568341.host, call_568341.base,
                         call_568341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568341, url, valid)

proc call*(call_568342: Call_AccountsCreateOrUpdate_568333;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; body: JsonNode): Recallable =
  ## accountsCreateOrUpdate
  ## Creates or updates a Visual Studio Team Services account resource.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   body: JObject (required)
  ##       : The request data.
  var path_568343 = newJObject()
  var query_568344 = newJObject()
  var body_568345 = newJObject()
  add(path_568343, "resourceGroupName", newJString(resourceGroupName))
  add(query_568344, "api-version", newJString(apiVersion))
  add(path_568343, "subscriptionId", newJString(subscriptionId))
  add(path_568343, "resourceName", newJString(resourceName))
  if body != nil:
    body_568345 = body
  result = call_568342.call(path_568343, query_568344, nil, nil, body_568345)

var accountsCreateOrUpdate* = Call_AccountsCreateOrUpdate_568333(
    name: "accountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{resourceName}",
    validator: validate_AccountsCreateOrUpdate_568334, base: "",
    url: url_AccountsCreateOrUpdate_568335, schemes: {Scheme.Https})
type
  Call_AccountsGet_568322 = ref object of OpenApiRestCall_567641
proc url_AccountsGet_568324(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.visualstudio/account/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsGet_568323(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Visual Studio Team Services account resource details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568325 = path.getOrDefault("resourceGroupName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "resourceGroupName", valid_568325
  var valid_568326 = path.getOrDefault("subscriptionId")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "subscriptionId", valid_568326
  var valid_568327 = path.getOrDefault("resourceName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "resourceName", valid_568327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568328 = query.getOrDefault("api-version")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "api-version", valid_568328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568329: Call_AccountsGet_568322; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Visual Studio Team Services account resource details.
  ## 
  let valid = call_568329.validator(path, query, header, formData, body)
  let scheme = call_568329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568329.url(scheme.get, call_568329.host, call_568329.base,
                         call_568329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568329, url, valid)

proc call*(call_568330: Call_AccountsGet_568322; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## accountsGet
  ## Gets the Visual Studio Team Services account resource details.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  var path_568331 = newJObject()
  var query_568332 = newJObject()
  add(path_568331, "resourceGroupName", newJString(resourceGroupName))
  add(query_568332, "api-version", newJString(apiVersion))
  add(path_568331, "subscriptionId", newJString(subscriptionId))
  add(path_568331, "resourceName", newJString(resourceName))
  result = call_568330.call(path_568331, query_568332, nil, nil, nil)

var accountsGet* = Call_AccountsGet_568322(name: "accountsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{resourceName}",
                                        validator: validate_AccountsGet_568323,
                                        base: "", url: url_AccountsGet_568324,
                                        schemes: {Scheme.Https})
type
  Call_AccountsUpdate_568357 = ref object of OpenApiRestCall_567641
proc url_AccountsUpdate_568359(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.visualstudio/account/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsUpdate_568358(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates tags for Visual Studio Team Services account resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568360 = path.getOrDefault("resourceGroupName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "resourceGroupName", valid_568360
  var valid_568361 = path.getOrDefault("subscriptionId")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "subscriptionId", valid_568361
  var valid_568362 = path.getOrDefault("resourceName")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "resourceName", valid_568362
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
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The request data.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568365: Call_AccountsUpdate_568357; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates tags for Visual Studio Team Services account resource.
  ## 
  let valid = call_568365.validator(path, query, header, formData, body)
  let scheme = call_568365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568365.url(scheme.get, call_568365.host, call_568365.base,
                         call_568365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568365, url, valid)

proc call*(call_568366: Call_AccountsUpdate_568357; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          body: JsonNode): Recallable =
  ## accountsUpdate
  ## Updates tags for Visual Studio Team Services account resource.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   body: JObject (required)
  ##       : The request data.
  var path_568367 = newJObject()
  var query_568368 = newJObject()
  var body_568369 = newJObject()
  add(path_568367, "resourceGroupName", newJString(resourceGroupName))
  add(query_568368, "api-version", newJString(apiVersion))
  add(path_568367, "subscriptionId", newJString(subscriptionId))
  add(path_568367, "resourceName", newJString(resourceName))
  if body != nil:
    body_568369 = body
  result = call_568366.call(path_568367, query_568368, nil, nil, body_568369)

var accountsUpdate* = Call_AccountsUpdate_568357(name: "accountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{resourceName}",
    validator: validate_AccountsUpdate_568358, base: "", url: url_AccountsUpdate_568359,
    schemes: {Scheme.Https})
type
  Call_AccountsDelete_568346 = ref object of OpenApiRestCall_567641
proc url_AccountsDelete_568348(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.visualstudio/account/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsDelete_568347(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a Visual Studio Team Services account resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568349 = path.getOrDefault("resourceGroupName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "resourceGroupName", valid_568349
  var valid_568350 = path.getOrDefault("subscriptionId")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "subscriptionId", valid_568350
  var valid_568351 = path.getOrDefault("resourceName")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "resourceName", valid_568351
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

proc call*(call_568353: Call_AccountsDelete_568346; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Visual Studio Team Services account resource.
  ## 
  let valid = call_568353.validator(path, query, header, formData, body)
  let scheme = call_568353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568353.url(scheme.get, call_568353.host, call_568353.base,
                         call_568353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568353, url, valid)

proc call*(call_568354: Call_AccountsDelete_568346; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## accountsDelete
  ## Deletes a Visual Studio Team Services account resource.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  var path_568355 = newJObject()
  var query_568356 = newJObject()
  add(path_568355, "resourceGroupName", newJString(resourceGroupName))
  add(query_568356, "api-version", newJString(apiVersion))
  add(path_568355, "subscriptionId", newJString(subscriptionId))
  add(path_568355, "resourceName", newJString(resourceName))
  result = call_568354.call(path_568355, query_568356, nil, nil, nil)

var accountsDelete* = Call_AccountsDelete_568346(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{resourceName}",
    validator: validate_AccountsDelete_568347, base: "", url: url_AccountsDelete_568348,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
