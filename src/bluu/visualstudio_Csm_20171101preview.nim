
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "visualstudio-Csm"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563761 = ref object of OpenApiRestCall_563539
proc url_OperationsList_563763(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563762(path: JsonNode; query: JsonNode;
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

proc call*(call_563868: Call_OperationsList_563761; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of all operations possible on the Microsoft.VisualStudio resource provider.
  ## 
  let valid = call_563868.validator(path, query, header, formData, body)
  let scheme = call_563868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563868.url(scheme.get, call_563868.host, call_563868.base,
                         call_563868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563868, url, valid)

proc call*(call_563952: Call_OperationsList_563761): Recallable =
  ## operationsList
  ## Gets the details of all operations possible on the Microsoft.VisualStudio resource provider.
  result = call_563952.call(nil, nil, nil, nil, nil)

var operationsList* = Call_OperationsList_563761(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/microsoft.visualstudio/operations",
    validator: validate_OperationsList_563762, base: "", url: url_OperationsList_563763,
    schemes: {Scheme.Https})
type
  Call_AccountsCheckNameAvailability_563990 = ref object of OpenApiRestCall_563539
proc url_AccountsCheckNameAvailability_563992(protocol: Scheme; host: string;
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

proc validate_AccountsCheckNameAvailability_563991(path: JsonNode; query: JsonNode;
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
  var valid_564072 = path.getOrDefault("subscriptionId")
  valid_564072 = validateParameter(valid_564072, JString, required = true,
                                 default = nil)
  if valid_564072 != nil:
    section.add "subscriptionId", valid_564072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564073 = query.getOrDefault("api-version")
  valid_564073 = validateParameter(valid_564073, JString, required = true,
                                 default = nil)
  if valid_564073 != nil:
    section.add "api-version", valid_564073
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

proc call*(call_564075: Call_AccountsCheckNameAvailability_563990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks if the specified Visual Studio Team Services account name is available. Resource name can be either an account name or an account name and PUID.
  ## 
  let valid = call_564075.validator(path, query, header, formData, body)
  let scheme = call_564075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564075.url(scheme.get, call_564075.host, call_564075.base,
                         call_564075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564075, url, valid)

proc call*(call_564076: Call_AccountsCheckNameAvailability_563990;
          apiVersion: string; subscriptionId: string; body: JsonNode): Recallable =
  ## accountsCheckNameAvailability
  ## Checks if the specified Visual Studio Team Services account name is available. Resource name can be either an account name or an account name and PUID.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   body: JObject (required)
  ##       : Parameters describing the name to check availability for.
  var path_564077 = newJObject()
  var query_564079 = newJObject()
  var body_564080 = newJObject()
  add(query_564079, "api-version", newJString(apiVersion))
  add(path_564077, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_564080 = body
  result = call_564076.call(path_564077, query_564079, nil, nil, body_564080)

var accountsCheckNameAvailability* = Call_AccountsCheckNameAvailability_563990(
    name: "accountsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/microsoft.visualstudio/checkNameAvailability",
    validator: validate_AccountsCheckNameAvailability_563991, base: "",
    url: url_AccountsCheckNameAvailability_563992, schemes: {Scheme.Https})
type
  Call_ProjectListByAccountResource_564082 = ref object of OpenApiRestCall_563539
proc url_ProjectListByAccountResource_564084(protocol: Scheme; host: string;
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

proc validate_ProjectListByAccountResource_564083(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all Visual Studio Team Services project resources created in the specified Team Services account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rootResourceName: JString (required)
  ##                   : Name of the Team Services account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rootResourceName` field"
  var valid_564085 = path.getOrDefault("rootResourceName")
  valid_564085 = validateParameter(valid_564085, JString, required = true,
                                 default = nil)
  if valid_564085 != nil:
    section.add "rootResourceName", valid_564085
  var valid_564086 = path.getOrDefault("subscriptionId")
  valid_564086 = validateParameter(valid_564086, JString, required = true,
                                 default = nil)
  if valid_564086 != nil:
    section.add "subscriptionId", valid_564086
  var valid_564087 = path.getOrDefault("resourceGroupName")
  valid_564087 = validateParameter(valid_564087, JString, required = true,
                                 default = nil)
  if valid_564087 != nil:
    section.add "resourceGroupName", valid_564087
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564088 = query.getOrDefault("api-version")
  valid_564088 = validateParameter(valid_564088, JString, required = true,
                                 default = nil)
  if valid_564088 != nil:
    section.add "api-version", valid_564088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564089: Call_ProjectListByAccountResource_564082; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Visual Studio Team Services project resources created in the specified Team Services account.
  ## 
  let valid = call_564089.validator(path, query, header, formData, body)
  let scheme = call_564089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564089.url(scheme.get, call_564089.host, call_564089.base,
                         call_564089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564089, url, valid)

proc call*(call_564090: Call_ProjectListByAccountResource_564082;
          rootResourceName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## projectListByAccountResource
  ## Gets all Visual Studio Team Services project resources created in the specified Team Services account.
  ##   rootResourceName: string (required)
  ##                   : Name of the Team Services account.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564091 = newJObject()
  var query_564092 = newJObject()
  add(path_564091, "rootResourceName", newJString(rootResourceName))
  add(query_564092, "api-version", newJString(apiVersion))
  add(path_564091, "subscriptionId", newJString(subscriptionId))
  add(path_564091, "resourceGroupName", newJString(resourceGroupName))
  result = call_564090.call(path_564091, query_564092, nil, nil, nil)

var projectListByAccountResource* = Call_ProjectListByAccountResource_564082(
    name: "projectListByAccountResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project",
    validator: validate_ProjectListByAccountResource_564083, base: "",
    url: url_ProjectListByAccountResource_564084, schemes: {Scheme.Https})
type
  Call_ProjectsCreate_564105 = ref object of OpenApiRestCall_563539
proc url_ProjectsCreate_564107(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsCreate_564106(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates a Team Services project in the collection with the specified name. 'VersionControlOption' and 'ProcessTemplateId' must be specified in the resource properties. Valid values for VersionControlOption: Git, Tfvc. Valid values for ProcessTemplateId: 6B724908-EF14-45CF-84F8-768B5384DA45, ADCC42AB-9882-485E-A3ED-7678F01F66BC, 27450541-8E31-4150-9947-DC59F998FC01 (these IDs correspond to Scrum, Agile, and CMMI process templates).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rootResourceName: JString (required)
  ##                   : Name of the Team Services account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   resourceName: JString (required)
  ##               : Name of the Team Services project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rootResourceName` field"
  var valid_564108 = path.getOrDefault("rootResourceName")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "rootResourceName", valid_564108
  var valid_564109 = path.getOrDefault("subscriptionId")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "subscriptionId", valid_564109
  var valid_564110 = path.getOrDefault("resourceGroupName")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "resourceGroupName", valid_564110
  var valid_564111 = path.getOrDefault("resourceName")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "resourceName", valid_564111
  result.add "path", section
  ## parameters in `query` object:
  ##   validating: JString
  ##             : This parameter is ignored and should be set to an empty string.
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  var valid_564112 = query.getOrDefault("validating")
  valid_564112 = validateParameter(valid_564112, JString, required = false,
                                 default = nil)
  if valid_564112 != nil:
    section.add "validating", valid_564112
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564113 = query.getOrDefault("api-version")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "api-version", valid_564113
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

proc call*(call_564115: Call_ProjectsCreate_564105; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Team Services project in the collection with the specified name. 'VersionControlOption' and 'ProcessTemplateId' must be specified in the resource properties. Valid values for VersionControlOption: Git, Tfvc. Valid values for ProcessTemplateId: 6B724908-EF14-45CF-84F8-768B5384DA45, ADCC42AB-9882-485E-A3ED-7678F01F66BC, 27450541-8E31-4150-9947-DC59F998FC01 (these IDs correspond to Scrum, Agile, and CMMI process templates).
  ## 
  let valid = call_564115.validator(path, query, header, formData, body)
  let scheme = call_564115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564115.url(scheme.get, call_564115.host, call_564115.base,
                         call_564115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564115, url, valid)

proc call*(call_564116: Call_ProjectsCreate_564105; rootResourceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          body: JsonNode; resourceName: string; validating: string = ""): Recallable =
  ## projectsCreate
  ## Creates a Team Services project in the collection with the specified name. 'VersionControlOption' and 'ProcessTemplateId' must be specified in the resource properties. Valid values for VersionControlOption: Git, Tfvc. Valid values for ProcessTemplateId: 6B724908-EF14-45CF-84F8-768B5384DA45, ADCC42AB-9882-485E-A3ED-7678F01F66BC, 27450541-8E31-4150-9947-DC59F998FC01 (these IDs correspond to Scrum, Agile, and CMMI process templates).
  ##   validating: string
  ##             : This parameter is ignored and should be set to an empty string.
  ##   rootResourceName: string (required)
  ##                   : Name of the Team Services account.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   body: JObject (required)
  ##       : The request data.
  ##   resourceName: string (required)
  ##               : Name of the Team Services project.
  var path_564117 = newJObject()
  var query_564118 = newJObject()
  var body_564119 = newJObject()
  add(query_564118, "validating", newJString(validating))
  add(path_564117, "rootResourceName", newJString(rootResourceName))
  add(query_564118, "api-version", newJString(apiVersion))
  add(path_564117, "subscriptionId", newJString(subscriptionId))
  add(path_564117, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564119 = body
  add(path_564117, "resourceName", newJString(resourceName))
  result = call_564116.call(path_564117, query_564118, nil, nil, body_564119)

var projectsCreate* = Call_ProjectsCreate_564105(name: "projectsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project/{resourceName}",
    validator: validate_ProjectsCreate_564106, base: "", url: url_ProjectsCreate_564107,
    schemes: {Scheme.Https})
type
  Call_ProjectsGet_564093 = ref object of OpenApiRestCall_563539
proc url_ProjectsGet_564095(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsGet_564094(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a Team Services project resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rootResourceName: JString (required)
  ##                   : Name of the Team Services account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   resourceName: JString (required)
  ##               : Name of the Team Services project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rootResourceName` field"
  var valid_564096 = path.getOrDefault("rootResourceName")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "rootResourceName", valid_564096
  var valid_564097 = path.getOrDefault("subscriptionId")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "subscriptionId", valid_564097
  var valid_564098 = path.getOrDefault("resourceGroupName")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "resourceGroupName", valid_564098
  var valid_564099 = path.getOrDefault("resourceName")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "resourceName", valid_564099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564100 = query.getOrDefault("api-version")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "api-version", valid_564100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564101: Call_ProjectsGet_564093; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a Team Services project resource.
  ## 
  let valid = call_564101.validator(path, query, header, formData, body)
  let scheme = call_564101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564101.url(scheme.get, call_564101.host, call_564101.base,
                         call_564101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564101, url, valid)

proc call*(call_564102: Call_ProjectsGet_564093; rootResourceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## projectsGet
  ## Gets the details of a Team Services project resource.
  ##   rootResourceName: string (required)
  ##                   : Name of the Team Services account.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   resourceName: string (required)
  ##               : Name of the Team Services project.
  var path_564103 = newJObject()
  var query_564104 = newJObject()
  add(path_564103, "rootResourceName", newJString(rootResourceName))
  add(query_564104, "api-version", newJString(apiVersion))
  add(path_564103, "subscriptionId", newJString(subscriptionId))
  add(path_564103, "resourceGroupName", newJString(resourceGroupName))
  add(path_564103, "resourceName", newJString(resourceName))
  result = call_564102.call(path_564103, query_564104, nil, nil, nil)

var projectsGet* = Call_ProjectsGet_564093(name: "projectsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project/{resourceName}",
                                        validator: validate_ProjectsGet_564094,
                                        base: "", url: url_ProjectsGet_564095,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsUpdate_564120 = ref object of OpenApiRestCall_563539
proc url_ProjectsUpdate_564122(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsUpdate_564121(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates the tags of the specified Team Services project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rootResourceName: JString (required)
  ##                   : Name of the Team Services account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   resourceName: JString (required)
  ##               : Name of the Team Services project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rootResourceName` field"
  var valid_564123 = path.getOrDefault("rootResourceName")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "rootResourceName", valid_564123
  var valid_564124 = path.getOrDefault("subscriptionId")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "subscriptionId", valid_564124
  var valid_564125 = path.getOrDefault("resourceGroupName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "resourceGroupName", valid_564125
  var valid_564126 = path.getOrDefault("resourceName")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "resourceName", valid_564126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564127 = query.getOrDefault("api-version")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "api-version", valid_564127
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

proc call*(call_564129: Call_ProjectsUpdate_564120; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tags of the specified Team Services project.
  ## 
  let valid = call_564129.validator(path, query, header, formData, body)
  let scheme = call_564129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564129.url(scheme.get, call_564129.host, call_564129.base,
                         call_564129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564129, url, valid)

proc call*(call_564130: Call_ProjectsUpdate_564120; rootResourceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          body: JsonNode; resourceName: string): Recallable =
  ## projectsUpdate
  ## Updates the tags of the specified Team Services project.
  ##   rootResourceName: string (required)
  ##                   : Name of the Team Services account.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   body: JObject (required)
  ##       : The request data.
  ##   resourceName: string (required)
  ##               : Name of the Team Services project.
  var path_564131 = newJObject()
  var query_564132 = newJObject()
  var body_564133 = newJObject()
  add(path_564131, "rootResourceName", newJString(rootResourceName))
  add(query_564132, "api-version", newJString(apiVersion))
  add(path_564131, "subscriptionId", newJString(subscriptionId))
  add(path_564131, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564133 = body
  add(path_564131, "resourceName", newJString(resourceName))
  result = call_564130.call(path_564131, query_564132, nil, nil, body_564133)

var projectsUpdate* = Call_ProjectsUpdate_564120(name: "projectsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project/{resourceName}",
    validator: validate_ProjectsUpdate_564121, base: "", url: url_ProjectsUpdate_564122,
    schemes: {Scheme.Https})
type
  Call_AccountsListByResourceGroup_564134 = ref object of OpenApiRestCall_563539
proc url_AccountsListByResourceGroup_564136(protocol: Scheme; host: string;
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

proc validate_AccountsListByResourceGroup_564135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all Visual Studio Team Services account resources under the resource group linked to the specified Azure subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564137 = path.getOrDefault("subscriptionId")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "subscriptionId", valid_564137
  var valid_564138 = path.getOrDefault("resourceGroupName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "resourceGroupName", valid_564138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564139 = query.getOrDefault("api-version")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "api-version", valid_564139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564140: Call_AccountsListByResourceGroup_564134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Visual Studio Team Services account resources under the resource group linked to the specified Azure subscription.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_AccountsListByResourceGroup_564134;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## accountsListByResourceGroup
  ## Gets all Visual Studio Team Services account resources under the resource group linked to the specified Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564142 = newJObject()
  var query_564143 = newJObject()
  add(query_564143, "api-version", newJString(apiVersion))
  add(path_564142, "subscriptionId", newJString(subscriptionId))
  add(path_564142, "resourceGroupName", newJString(resourceGroupName))
  result = call_564141.call(path_564142, query_564143, nil, nil, nil)

var accountsListByResourceGroup* = Call_AccountsListByResourceGroup_564134(
    name: "accountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account",
    validator: validate_AccountsListByResourceGroup_564135, base: "",
    url: url_AccountsListByResourceGroup_564136, schemes: {Scheme.Https})
type
  Call_ExtensionsListByAccount_564144 = ref object of OpenApiRestCall_563539
proc url_ExtensionsListByAccount_564146(protocol: Scheme; host: string; base: string;
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

proc validate_ExtensionsListByAccount_564145(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the extension resources created within the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   accountResourceName: JString (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564147 = path.getOrDefault("subscriptionId")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "subscriptionId", valid_564147
  var valid_564148 = path.getOrDefault("accountResourceName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "accountResourceName", valid_564148
  var valid_564149 = path.getOrDefault("resourceGroupName")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "resourceGroupName", valid_564149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564150 = query.getOrDefault("api-version")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "api-version", valid_564150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564151: Call_ExtensionsListByAccount_564144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the extension resources created within the resource group.
  ## 
  let valid = call_564151.validator(path, query, header, formData, body)
  let scheme = call_564151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564151.url(scheme.get, call_564151.host, call_564151.base,
                         call_564151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564151, url, valid)

proc call*(call_564152: Call_ExtensionsListByAccount_564144; apiVersion: string;
          subscriptionId: string; accountResourceName: string;
          resourceGroupName: string): Recallable =
  ## extensionsListByAccount
  ## Gets the details of the extension resources created within the resource group.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   accountResourceName: string (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564153 = newJObject()
  var query_564154 = newJObject()
  add(query_564154, "api-version", newJString(apiVersion))
  add(path_564153, "subscriptionId", newJString(subscriptionId))
  add(path_564153, "accountResourceName", newJString(accountResourceName))
  add(path_564153, "resourceGroupName", newJString(resourceGroupName))
  result = call_564152.call(path_564153, query_564154, nil, nil, nil)

var extensionsListByAccount* = Call_ExtensionsListByAccount_564144(
    name: "extensionsListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension",
    validator: validate_ExtensionsListByAccount_564145, base: "",
    url: url_ExtensionsListByAccount_564146, schemes: {Scheme.Https})
type
  Call_ExtensionsCreate_564167 = ref object of OpenApiRestCall_563539
proc url_ExtensionsCreate_564169(protocol: Scheme; host: string; base: string;
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

proc validate_ExtensionsCreate_564168(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Registers the extension with a Visual Studio Team Services account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   accountResourceName: JString (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   extensionResourceName: JString (required)
  ##                        : The name of the extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564170 = path.getOrDefault("subscriptionId")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "subscriptionId", valid_564170
  var valid_564171 = path.getOrDefault("accountResourceName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "accountResourceName", valid_564171
  var valid_564172 = path.getOrDefault("resourceGroupName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "resourceGroupName", valid_564172
  var valid_564173 = path.getOrDefault("extensionResourceName")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "extensionResourceName", valid_564173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564174 = query.getOrDefault("api-version")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "api-version", valid_564174
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

proc call*(call_564176: Call_ExtensionsCreate_564167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers the extension with a Visual Studio Team Services account.
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_ExtensionsCreate_564167; apiVersion: string;
          subscriptionId: string; accountResourceName: string;
          resourceGroupName: string; body: JsonNode; extensionResourceName: string): Recallable =
  ## extensionsCreate
  ## Registers the extension with a Visual Studio Team Services account.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   accountResourceName: string (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   body: JObject (required)
  ##       : An object containing additional information related to the extension request.
  ##   extensionResourceName: string (required)
  ##                        : The name of the extension.
  var path_564178 = newJObject()
  var query_564179 = newJObject()
  var body_564180 = newJObject()
  add(query_564179, "api-version", newJString(apiVersion))
  add(path_564178, "subscriptionId", newJString(subscriptionId))
  add(path_564178, "accountResourceName", newJString(accountResourceName))
  add(path_564178, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564180 = body
  add(path_564178, "extensionResourceName", newJString(extensionResourceName))
  result = call_564177.call(path_564178, query_564179, nil, nil, body_564180)

var extensionsCreate* = Call_ExtensionsCreate_564167(name: "extensionsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension/{extensionResourceName}",
    validator: validate_ExtensionsCreate_564168, base: "",
    url: url_ExtensionsCreate_564169, schemes: {Scheme.Https})
type
  Call_ExtensionsGet_564155 = ref object of OpenApiRestCall_563539
proc url_ExtensionsGet_564157(protocol: Scheme; host: string; base: string;
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

proc validate_ExtensionsGet_564156(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of an extension associated with a Visual Studio Team Services account resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   accountResourceName: JString (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   extensionResourceName: JString (required)
  ##                        : The name of the extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564158 = path.getOrDefault("subscriptionId")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "subscriptionId", valid_564158
  var valid_564159 = path.getOrDefault("accountResourceName")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "accountResourceName", valid_564159
  var valid_564160 = path.getOrDefault("resourceGroupName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "resourceGroupName", valid_564160
  var valid_564161 = path.getOrDefault("extensionResourceName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "extensionResourceName", valid_564161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564162 = query.getOrDefault("api-version")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "api-version", valid_564162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564163: Call_ExtensionsGet_564155; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an extension associated with a Visual Studio Team Services account resource.
  ## 
  let valid = call_564163.validator(path, query, header, formData, body)
  let scheme = call_564163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564163.url(scheme.get, call_564163.host, call_564163.base,
                         call_564163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564163, url, valid)

proc call*(call_564164: Call_ExtensionsGet_564155; apiVersion: string;
          subscriptionId: string; accountResourceName: string;
          resourceGroupName: string; extensionResourceName: string): Recallable =
  ## extensionsGet
  ## Gets the details of an extension associated with a Visual Studio Team Services account resource.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   accountResourceName: string (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   extensionResourceName: string (required)
  ##                        : The name of the extension.
  var path_564165 = newJObject()
  var query_564166 = newJObject()
  add(query_564166, "api-version", newJString(apiVersion))
  add(path_564165, "subscriptionId", newJString(subscriptionId))
  add(path_564165, "accountResourceName", newJString(accountResourceName))
  add(path_564165, "resourceGroupName", newJString(resourceGroupName))
  add(path_564165, "extensionResourceName", newJString(extensionResourceName))
  result = call_564164.call(path_564165, query_564166, nil, nil, nil)

var extensionsGet* = Call_ExtensionsGet_564155(name: "extensionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension/{extensionResourceName}",
    validator: validate_ExtensionsGet_564156, base: "", url: url_ExtensionsGet_564157,
    schemes: {Scheme.Https})
type
  Call_ExtensionsUpdate_564193 = ref object of OpenApiRestCall_563539
proc url_ExtensionsUpdate_564195(protocol: Scheme; host: string; base: string;
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

proc validate_ExtensionsUpdate_564194(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates an existing extension registration for the Visual Studio Team Services account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   accountResourceName: JString (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   extensionResourceName: JString (required)
  ##                        : The name of the extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564196 = path.getOrDefault("subscriptionId")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "subscriptionId", valid_564196
  var valid_564197 = path.getOrDefault("accountResourceName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "accountResourceName", valid_564197
  var valid_564198 = path.getOrDefault("resourceGroupName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "resourceGroupName", valid_564198
  var valid_564199 = path.getOrDefault("extensionResourceName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "extensionResourceName", valid_564199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564200 = query.getOrDefault("api-version")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "api-version", valid_564200
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

proc call*(call_564202: Call_ExtensionsUpdate_564193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing extension registration for the Visual Studio Team Services account.
  ## 
  let valid = call_564202.validator(path, query, header, formData, body)
  let scheme = call_564202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564202.url(scheme.get, call_564202.host, call_564202.base,
                         call_564202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564202, url, valid)

proc call*(call_564203: Call_ExtensionsUpdate_564193; apiVersion: string;
          subscriptionId: string; accountResourceName: string;
          resourceGroupName: string; body: JsonNode; extensionResourceName: string): Recallable =
  ## extensionsUpdate
  ## Updates an existing extension registration for the Visual Studio Team Services account.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   accountResourceName: string (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   body: JObject (required)
  ##       : An object containing additional information related to the extension request.
  ##   extensionResourceName: string (required)
  ##                        : The name of the extension.
  var path_564204 = newJObject()
  var query_564205 = newJObject()
  var body_564206 = newJObject()
  add(query_564205, "api-version", newJString(apiVersion))
  add(path_564204, "subscriptionId", newJString(subscriptionId))
  add(path_564204, "accountResourceName", newJString(accountResourceName))
  add(path_564204, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564206 = body
  add(path_564204, "extensionResourceName", newJString(extensionResourceName))
  result = call_564203.call(path_564204, query_564205, nil, nil, body_564206)

var extensionsUpdate* = Call_ExtensionsUpdate_564193(name: "extensionsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension/{extensionResourceName}",
    validator: validate_ExtensionsUpdate_564194, base: "",
    url: url_ExtensionsUpdate_564195, schemes: {Scheme.Https})
type
  Call_ExtensionsDelete_564181 = ref object of OpenApiRestCall_563539
proc url_ExtensionsDelete_564183(protocol: Scheme; host: string; base: string;
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

proc validate_ExtensionsDelete_564182(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Removes an extension resource registration for a Visual Studio Team Services account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   accountResourceName: JString (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   extensionResourceName: JString (required)
  ##                        : The name of the extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564184 = path.getOrDefault("subscriptionId")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "subscriptionId", valid_564184
  var valid_564185 = path.getOrDefault("accountResourceName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "accountResourceName", valid_564185
  var valid_564186 = path.getOrDefault("resourceGroupName")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "resourceGroupName", valid_564186
  var valid_564187 = path.getOrDefault("extensionResourceName")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "extensionResourceName", valid_564187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564188 = query.getOrDefault("api-version")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "api-version", valid_564188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564189: Call_ExtensionsDelete_564181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes an extension resource registration for a Visual Studio Team Services account.
  ## 
  let valid = call_564189.validator(path, query, header, formData, body)
  let scheme = call_564189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564189.url(scheme.get, call_564189.host, call_564189.base,
                         call_564189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564189, url, valid)

proc call*(call_564190: Call_ExtensionsDelete_564181; apiVersion: string;
          subscriptionId: string; accountResourceName: string;
          resourceGroupName: string; extensionResourceName: string): Recallable =
  ## extensionsDelete
  ## Removes an extension resource registration for a Visual Studio Team Services account.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   accountResourceName: string (required)
  ##                      : The name of the Visual Studio Team Services account resource.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   extensionResourceName: string (required)
  ##                        : The name of the extension.
  var path_564191 = newJObject()
  var query_564192 = newJObject()
  add(query_564192, "api-version", newJString(apiVersion))
  add(path_564191, "subscriptionId", newJString(subscriptionId))
  add(path_564191, "accountResourceName", newJString(accountResourceName))
  add(path_564191, "resourceGroupName", newJString(resourceGroupName))
  add(path_564191, "extensionResourceName", newJString(extensionResourceName))
  result = call_564190.call(path_564191, query_564192, nil, nil, nil)

var extensionsDelete* = Call_ExtensionsDelete_564181(name: "extensionsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension/{extensionResourceName}",
    validator: validate_ExtensionsDelete_564182, base: "",
    url: url_ExtensionsDelete_564183, schemes: {Scheme.Https})
type
  Call_AccountsCreateOrUpdate_564218 = ref object of OpenApiRestCall_563539
proc url_AccountsCreateOrUpdate_564220(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsCreateOrUpdate_564219(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Visual Studio Team Services account resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564221 = path.getOrDefault("subscriptionId")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "subscriptionId", valid_564221
  var valid_564222 = path.getOrDefault("resourceGroupName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "resourceGroupName", valid_564222
  var valid_564223 = path.getOrDefault("resourceName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "resourceName", valid_564223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564224 = query.getOrDefault("api-version")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "api-version", valid_564224
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

proc call*(call_564226: Call_AccountsCreateOrUpdate_564218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Visual Studio Team Services account resource.
  ## 
  let valid = call_564226.validator(path, query, header, formData, body)
  let scheme = call_564226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564226.url(scheme.get, call_564226.host, call_564226.base,
                         call_564226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564226, url, valid)

proc call*(call_564227: Call_AccountsCreateOrUpdate_564218; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; body: JsonNode;
          resourceName: string): Recallable =
  ## accountsCreateOrUpdate
  ## Creates or updates a Visual Studio Team Services account resource.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   body: JObject (required)
  ##       : The request data.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  var path_564228 = newJObject()
  var query_564229 = newJObject()
  var body_564230 = newJObject()
  add(query_564229, "api-version", newJString(apiVersion))
  add(path_564228, "subscriptionId", newJString(subscriptionId))
  add(path_564228, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564230 = body
  add(path_564228, "resourceName", newJString(resourceName))
  result = call_564227.call(path_564228, query_564229, nil, nil, body_564230)

var accountsCreateOrUpdate* = Call_AccountsCreateOrUpdate_564218(
    name: "accountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{resourceName}",
    validator: validate_AccountsCreateOrUpdate_564219, base: "",
    url: url_AccountsCreateOrUpdate_564220, schemes: {Scheme.Https})
type
  Call_AccountsGet_564207 = ref object of OpenApiRestCall_563539
proc url_AccountsGet_564209(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsGet_564208(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Visual Studio Team Services account resource details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564210 = path.getOrDefault("subscriptionId")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "subscriptionId", valid_564210
  var valid_564211 = path.getOrDefault("resourceGroupName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "resourceGroupName", valid_564211
  var valid_564212 = path.getOrDefault("resourceName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "resourceName", valid_564212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564213 = query.getOrDefault("api-version")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "api-version", valid_564213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564214: Call_AccountsGet_564207; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Visual Studio Team Services account resource details.
  ## 
  let valid = call_564214.validator(path, query, header, formData, body)
  let scheme = call_564214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564214.url(scheme.get, call_564214.host, call_564214.base,
                         call_564214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564214, url, valid)

proc call*(call_564215: Call_AccountsGet_564207; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## accountsGet
  ## Gets the Visual Studio Team Services account resource details.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  var path_564216 = newJObject()
  var query_564217 = newJObject()
  add(query_564217, "api-version", newJString(apiVersion))
  add(path_564216, "subscriptionId", newJString(subscriptionId))
  add(path_564216, "resourceGroupName", newJString(resourceGroupName))
  add(path_564216, "resourceName", newJString(resourceName))
  result = call_564215.call(path_564216, query_564217, nil, nil, nil)

var accountsGet* = Call_AccountsGet_564207(name: "accountsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{resourceName}",
                                        validator: validate_AccountsGet_564208,
                                        base: "", url: url_AccountsGet_564209,
                                        schemes: {Scheme.Https})
type
  Call_AccountsDelete_564231 = ref object of OpenApiRestCall_563539
proc url_AccountsDelete_564233(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsDelete_564232(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a Visual Studio Team Services account resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564234 = path.getOrDefault("subscriptionId")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "subscriptionId", valid_564234
  var valid_564235 = path.getOrDefault("resourceGroupName")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "resourceGroupName", valid_564235
  var valid_564236 = path.getOrDefault("resourceName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "resourceName", valid_564236
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

proc call*(call_564238: Call_AccountsDelete_564231; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Visual Studio Team Services account resource.
  ## 
  let valid = call_564238.validator(path, query, header, formData, body)
  let scheme = call_564238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564238.url(scheme.get, call_564238.host, call_564238.base,
                         call_564238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564238, url, valid)

proc call*(call_564239: Call_AccountsDelete_564231; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## accountsDelete
  ## Deletes a Visual Studio Team Services account resource.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  var path_564240 = newJObject()
  var query_564241 = newJObject()
  add(query_564241, "api-version", newJString(apiVersion))
  add(path_564240, "subscriptionId", newJString(subscriptionId))
  add(path_564240, "resourceGroupName", newJString(resourceGroupName))
  add(path_564240, "resourceName", newJString(resourceName))
  result = call_564239.call(path_564240, query_564241, nil, nil, nil)

var accountsDelete* = Call_AccountsDelete_564231(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{resourceName}",
    validator: validate_AccountsDelete_564232, base: "", url: url_AccountsDelete_564233,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
