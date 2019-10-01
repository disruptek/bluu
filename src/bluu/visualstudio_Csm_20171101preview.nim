
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Visual Studio Resource Provider Client
## version: 2017-11-01-preview
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
  Call_ProjectListByAccountResource_568182 = ref object of OpenApiRestCall_567641
proc url_ProjectListByAccountResource_568184(protocol: Scheme; host: string;
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

proc validate_ProjectListByAccountResource_568183(path: JsonNode; query: JsonNode;
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

proc call*(call_568189: Call_ProjectListByAccountResource_568182; path: JsonNode;
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

proc call*(call_568190: Call_ProjectListByAccountResource_568182;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          rootResourceName: string): Recallable =
  ## projectListByAccountResource
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

var projectListByAccountResource* = Call_ProjectListByAccountResource_568182(
    name: "projectListByAccountResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project",
    validator: validate_ProjectListByAccountResource_568183, base: "",
    url: url_ProjectListByAccountResource_568184, schemes: {Scheme.Https})
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
  Call_AccountsListByResourceGroup_568234 = ref object of OpenApiRestCall_567641
proc url_AccountsListByResourceGroup_568236(protocol: Scheme; host: string;
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

proc validate_AccountsListByResourceGroup_568235(path: JsonNode; query: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568239 = query.getOrDefault("api-version")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "api-version", valid_568239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568240: Call_AccountsListByResourceGroup_568234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Visual Studio Team Services account resources under the resource group linked to the specified Azure subscription.
  ## 
  let valid = call_568240.validator(path, query, header, formData, body)
  let scheme = call_568240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568240.url(scheme.get, call_568240.host, call_568240.base,
                         call_568240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568240, url, valid)

proc call*(call_568241: Call_AccountsListByResourceGroup_568234;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## accountsListByResourceGroup
  ## Gets all Visual Studio Team Services account resources under the resource group linked to the specified Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  var path_568242 = newJObject()
  var query_568243 = newJObject()
  add(path_568242, "resourceGroupName", newJString(resourceGroupName))
  add(query_568243, "api-version", newJString(apiVersion))
  add(path_568242, "subscriptionId", newJString(subscriptionId))
  result = call_568241.call(path_568242, query_568243, nil, nil, nil)

var accountsListByResourceGroup* = Call_AccountsListByResourceGroup_568234(
    name: "accountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account",
    validator: validate_AccountsListByResourceGroup_568235, base: "",
    url: url_AccountsListByResourceGroup_568236, schemes: {Scheme.Https})
type
  Call_ExtensionsListByAccount_568244 = ref object of OpenApiRestCall_567641
proc url_ExtensionsListByAccount_568246(protocol: Scheme; host: string; base: string;
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

proc validate_ExtensionsListByAccount_568245(path: JsonNode; query: JsonNode;
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
  var valid_568247 = path.getOrDefault("resourceGroupName")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "resourceGroupName", valid_568247
  var valid_568248 = path.getOrDefault("subscriptionId")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "subscriptionId", valid_568248
  var valid_568249 = path.getOrDefault("accountResourceName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "accountResourceName", valid_568249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568250 = query.getOrDefault("api-version")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "api-version", valid_568250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568251: Call_ExtensionsListByAccount_568244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the extension resources created within the resource group.
  ## 
  let valid = call_568251.validator(path, query, header, formData, body)
  let scheme = call_568251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568251.url(scheme.get, call_568251.host, call_568251.base,
                         call_568251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568251, url, valid)

proc call*(call_568252: Call_ExtensionsListByAccount_568244;
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
  var path_568253 = newJObject()
  var query_568254 = newJObject()
  add(path_568253, "resourceGroupName", newJString(resourceGroupName))
  add(query_568254, "api-version", newJString(apiVersion))
  add(path_568253, "subscriptionId", newJString(subscriptionId))
  add(path_568253, "accountResourceName", newJString(accountResourceName))
  result = call_568252.call(path_568253, query_568254, nil, nil, nil)

var extensionsListByAccount* = Call_ExtensionsListByAccount_568244(
    name: "extensionsListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension",
    validator: validate_ExtensionsListByAccount_568245, base: "",
    url: url_ExtensionsListByAccount_568246, schemes: {Scheme.Https})
type
  Call_ExtensionsCreate_568267 = ref object of OpenApiRestCall_567641
proc url_ExtensionsCreate_568269(protocol: Scheme; host: string; base: string;
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

proc validate_ExtensionsCreate_568268(path: JsonNode; query: JsonNode;
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
  var valid_568272 = path.getOrDefault("extensionResourceName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "extensionResourceName", valid_568272
  var valid_568273 = path.getOrDefault("accountResourceName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "accountResourceName", valid_568273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568274 = query.getOrDefault("api-version")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "api-version", valid_568274
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

proc call*(call_568276: Call_ExtensionsCreate_568267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers the extension with a Visual Studio Team Services account.
  ## 
  let valid = call_568276.validator(path, query, header, formData, body)
  let scheme = call_568276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568276.url(scheme.get, call_568276.host, call_568276.base,
                         call_568276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568276, url, valid)

proc call*(call_568277: Call_ExtensionsCreate_568267; resourceGroupName: string;
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
  var path_568278 = newJObject()
  var query_568279 = newJObject()
  var body_568280 = newJObject()
  add(path_568278, "resourceGroupName", newJString(resourceGroupName))
  add(query_568279, "api-version", newJString(apiVersion))
  add(path_568278, "subscriptionId", newJString(subscriptionId))
  add(path_568278, "extensionResourceName", newJString(extensionResourceName))
  add(path_568278, "accountResourceName", newJString(accountResourceName))
  if body != nil:
    body_568280 = body
  result = call_568277.call(path_568278, query_568279, nil, nil, body_568280)

var extensionsCreate* = Call_ExtensionsCreate_568267(name: "extensionsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension/{extensionResourceName}",
    validator: validate_ExtensionsCreate_568268, base: "",
    url: url_ExtensionsCreate_568269, schemes: {Scheme.Https})
type
  Call_ExtensionsGet_568255 = ref object of OpenApiRestCall_567641
proc url_ExtensionsGet_568257(protocol: Scheme; host: string; base: string;
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

proc validate_ExtensionsGet_568256(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568258 = path.getOrDefault("resourceGroupName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "resourceGroupName", valid_568258
  var valid_568259 = path.getOrDefault("subscriptionId")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "subscriptionId", valid_568259
  var valid_568260 = path.getOrDefault("extensionResourceName")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "extensionResourceName", valid_568260
  var valid_568261 = path.getOrDefault("accountResourceName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "accountResourceName", valid_568261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568262 = query.getOrDefault("api-version")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "api-version", valid_568262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568263: Call_ExtensionsGet_568255; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an extension associated with a Visual Studio Team Services account resource.
  ## 
  let valid = call_568263.validator(path, query, header, formData, body)
  let scheme = call_568263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568263.url(scheme.get, call_568263.host, call_568263.base,
                         call_568263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568263, url, valid)

proc call*(call_568264: Call_ExtensionsGet_568255; resourceGroupName: string;
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
  var path_568265 = newJObject()
  var query_568266 = newJObject()
  add(path_568265, "resourceGroupName", newJString(resourceGroupName))
  add(query_568266, "api-version", newJString(apiVersion))
  add(path_568265, "subscriptionId", newJString(subscriptionId))
  add(path_568265, "extensionResourceName", newJString(extensionResourceName))
  add(path_568265, "accountResourceName", newJString(accountResourceName))
  result = call_568264.call(path_568265, query_568266, nil, nil, nil)

var extensionsGet* = Call_ExtensionsGet_568255(name: "extensionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension/{extensionResourceName}",
    validator: validate_ExtensionsGet_568256, base: "", url: url_ExtensionsGet_568257,
    schemes: {Scheme.Https})
type
  Call_ExtensionsUpdate_568293 = ref object of OpenApiRestCall_567641
proc url_ExtensionsUpdate_568295(protocol: Scheme; host: string; base: string;
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

proc validate_ExtensionsUpdate_568294(path: JsonNode; query: JsonNode;
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
  var valid_568296 = path.getOrDefault("resourceGroupName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "resourceGroupName", valid_568296
  var valid_568297 = path.getOrDefault("subscriptionId")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "subscriptionId", valid_568297
  var valid_568298 = path.getOrDefault("extensionResourceName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "extensionResourceName", valid_568298
  var valid_568299 = path.getOrDefault("accountResourceName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "accountResourceName", valid_568299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
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
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : An object containing additional information related to the extension request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568302: Call_ExtensionsUpdate_568293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing extension registration for the Visual Studio Team Services account.
  ## 
  let valid = call_568302.validator(path, query, header, formData, body)
  let scheme = call_568302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568302.url(scheme.get, call_568302.host, call_568302.base,
                         call_568302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568302, url, valid)

proc call*(call_568303: Call_ExtensionsUpdate_568293; resourceGroupName: string;
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
  var path_568304 = newJObject()
  var query_568305 = newJObject()
  var body_568306 = newJObject()
  add(path_568304, "resourceGroupName", newJString(resourceGroupName))
  add(query_568305, "api-version", newJString(apiVersion))
  add(path_568304, "subscriptionId", newJString(subscriptionId))
  add(path_568304, "extensionResourceName", newJString(extensionResourceName))
  add(path_568304, "accountResourceName", newJString(accountResourceName))
  if body != nil:
    body_568306 = body
  result = call_568303.call(path_568304, query_568305, nil, nil, body_568306)

var extensionsUpdate* = Call_ExtensionsUpdate_568293(name: "extensionsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension/{extensionResourceName}",
    validator: validate_ExtensionsUpdate_568294, base: "",
    url: url_ExtensionsUpdate_568295, schemes: {Scheme.Https})
type
  Call_ExtensionsDelete_568281 = ref object of OpenApiRestCall_567641
proc url_ExtensionsDelete_568283(protocol: Scheme; host: string; base: string;
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

proc validate_ExtensionsDelete_568282(path: JsonNode; query: JsonNode;
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
  var valid_568284 = path.getOrDefault("resourceGroupName")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "resourceGroupName", valid_568284
  var valid_568285 = path.getOrDefault("subscriptionId")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "subscriptionId", valid_568285
  var valid_568286 = path.getOrDefault("extensionResourceName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "extensionResourceName", valid_568286
  var valid_568287 = path.getOrDefault("accountResourceName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "accountResourceName", valid_568287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568288 = query.getOrDefault("api-version")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "api-version", valid_568288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568289: Call_ExtensionsDelete_568281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes an extension resource registration for a Visual Studio Team Services account.
  ## 
  let valid = call_568289.validator(path, query, header, formData, body)
  let scheme = call_568289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568289.url(scheme.get, call_568289.host, call_568289.base,
                         call_568289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568289, url, valid)

proc call*(call_568290: Call_ExtensionsDelete_568281; resourceGroupName: string;
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
  var path_568291 = newJObject()
  var query_568292 = newJObject()
  add(path_568291, "resourceGroupName", newJString(resourceGroupName))
  add(query_568292, "api-version", newJString(apiVersion))
  add(path_568291, "subscriptionId", newJString(subscriptionId))
  add(path_568291, "extensionResourceName", newJString(extensionResourceName))
  add(path_568291, "accountResourceName", newJString(accountResourceName))
  result = call_568290.call(path_568291, query_568292, nil, nil, nil)

var extensionsDelete* = Call_ExtensionsDelete_568281(name: "extensionsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension/{extensionResourceName}",
    validator: validate_ExtensionsDelete_568282, base: "",
    url: url_ExtensionsDelete_568283, schemes: {Scheme.Https})
type
  Call_AccountsCreateOrUpdate_568318 = ref object of OpenApiRestCall_567641
proc url_AccountsCreateOrUpdate_568320(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsCreateOrUpdate_568319(path: JsonNode; query: JsonNode;
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
  var valid_568321 = path.getOrDefault("resourceGroupName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "resourceGroupName", valid_568321
  var valid_568322 = path.getOrDefault("subscriptionId")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "subscriptionId", valid_568322
  var valid_568323 = path.getOrDefault("resourceName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "resourceName", valid_568323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568324 = query.getOrDefault("api-version")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "api-version", valid_568324
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

proc call*(call_568326: Call_AccountsCreateOrUpdate_568318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Visual Studio Team Services account resource.
  ## 
  let valid = call_568326.validator(path, query, header, formData, body)
  let scheme = call_568326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568326.url(scheme.get, call_568326.host, call_568326.base,
                         call_568326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568326, url, valid)

proc call*(call_568327: Call_AccountsCreateOrUpdate_568318;
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
  var path_568328 = newJObject()
  var query_568329 = newJObject()
  var body_568330 = newJObject()
  add(path_568328, "resourceGroupName", newJString(resourceGroupName))
  add(query_568329, "api-version", newJString(apiVersion))
  add(path_568328, "subscriptionId", newJString(subscriptionId))
  add(path_568328, "resourceName", newJString(resourceName))
  if body != nil:
    body_568330 = body
  result = call_568327.call(path_568328, query_568329, nil, nil, body_568330)

var accountsCreateOrUpdate* = Call_AccountsCreateOrUpdate_568318(
    name: "accountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{resourceName}",
    validator: validate_AccountsCreateOrUpdate_568319, base: "",
    url: url_AccountsCreateOrUpdate_568320, schemes: {Scheme.Https})
type
  Call_AccountsGet_568307 = ref object of OpenApiRestCall_567641
proc url_AccountsGet_568309(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsGet_568308(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568310 = path.getOrDefault("resourceGroupName")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "resourceGroupName", valid_568310
  var valid_568311 = path.getOrDefault("subscriptionId")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "subscriptionId", valid_568311
  var valid_568312 = path.getOrDefault("resourceName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "resourceName", valid_568312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568313 = query.getOrDefault("api-version")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "api-version", valid_568313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568314: Call_AccountsGet_568307; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Visual Studio Team Services account resource details.
  ## 
  let valid = call_568314.validator(path, query, header, formData, body)
  let scheme = call_568314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568314.url(scheme.get, call_568314.host, call_568314.base,
                         call_568314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568314, url, valid)

proc call*(call_568315: Call_AccountsGet_568307; resourceGroupName: string;
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
  var path_568316 = newJObject()
  var query_568317 = newJObject()
  add(path_568316, "resourceGroupName", newJString(resourceGroupName))
  add(query_568317, "api-version", newJString(apiVersion))
  add(path_568316, "subscriptionId", newJString(subscriptionId))
  add(path_568316, "resourceName", newJString(resourceName))
  result = call_568315.call(path_568316, query_568317, nil, nil, nil)

var accountsGet* = Call_AccountsGet_568307(name: "accountsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{resourceName}",
                                        validator: validate_AccountsGet_568308,
                                        base: "", url: url_AccountsGet_568309,
                                        schemes: {Scheme.Https})
type
  Call_AccountsDelete_568331 = ref object of OpenApiRestCall_567641
proc url_AccountsDelete_568333(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsDelete_568332(path: JsonNode; query: JsonNode;
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
  var valid_568334 = path.getOrDefault("resourceGroupName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "resourceGroupName", valid_568334
  var valid_568335 = path.getOrDefault("subscriptionId")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "subscriptionId", valid_568335
  var valid_568336 = path.getOrDefault("resourceName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "resourceName", valid_568336
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

proc call*(call_568338: Call_AccountsDelete_568331; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Visual Studio Team Services account resource.
  ## 
  let valid = call_568338.validator(path, query, header, formData, body)
  let scheme = call_568338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568338.url(scheme.get, call_568338.host, call_568338.base,
                         call_568338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568338, url, valid)

proc call*(call_568339: Call_AccountsDelete_568331; resourceGroupName: string;
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
  var path_568340 = newJObject()
  var query_568341 = newJObject()
  add(path_568340, "resourceGroupName", newJString(resourceGroupName))
  add(query_568341, "api-version", newJString(apiVersion))
  add(path_568340, "subscriptionId", newJString(subscriptionId))
  add(path_568340, "resourceName", newJString(resourceName))
  result = call_568339.call(path_568340, query_568341, nil, nil, nil)

var accountsDelete* = Call_AccountsDelete_568331(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{resourceName}",
    validator: validate_AccountsDelete_568332, base: "", url: url_AccountsDelete_568333,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
