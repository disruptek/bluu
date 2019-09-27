
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_OperationsList_593630 = ref object of OpenApiRestCall_593408
proc url_OperationsList_593632(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593631(path: JsonNode; query: JsonNode;
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

proc call*(call_593737: Call_OperationsList_593630; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of all operations possible on the Microsoft.VisualStudio resource provider.
  ## 
  let valid = call_593737.validator(path, query, header, formData, body)
  let scheme = call_593737.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593737.url(scheme.get, call_593737.host, call_593737.base,
                         call_593737.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593737, url, valid)

proc call*(call_593821: Call_OperationsList_593630): Recallable =
  ## operationsList
  ## Gets the details of all operations possible on the Microsoft.VisualStudio resource provider.
  result = call_593821.call(nil, nil, nil, nil, nil)

var operationsList* = Call_OperationsList_593630(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/microsoft.visualstudio/operations",
    validator: validate_OperationsList_593631, base: "", url: url_OperationsList_593632,
    schemes: {Scheme.Https})
type
  Call_AccountsCheckNameAvailability_593859 = ref object of OpenApiRestCall_593408
proc url_AccountsCheckNameAvailability_593861(protocol: Scheme; host: string;
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

proc validate_AccountsCheckNameAvailability_593860(path: JsonNode; query: JsonNode;
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
  var valid_593939 = path.getOrDefault("subscriptionId")
  valid_593939 = validateParameter(valid_593939, JString, required = true,
                                 default = nil)
  if valid_593939 != nil:
    section.add "subscriptionId", valid_593939
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593940 = query.getOrDefault("api-version")
  valid_593940 = validateParameter(valid_593940, JString, required = true,
                                 default = nil)
  if valid_593940 != nil:
    section.add "api-version", valid_593940
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

proc call*(call_593942: Call_AccountsCheckNameAvailability_593859; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks if the specified Visual Studio Team Services account name is available. Resource name can be either an account name or an account name and PUID.
  ## 
  let valid = call_593942.validator(path, query, header, formData, body)
  let scheme = call_593942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593942.url(scheme.get, call_593942.host, call_593942.base,
                         call_593942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593942, url, valid)

proc call*(call_593943: Call_AccountsCheckNameAvailability_593859;
          apiVersion: string; subscriptionId: string; body: JsonNode): Recallable =
  ## accountsCheckNameAvailability
  ## Checks if the specified Visual Studio Team Services account name is available. Resource name can be either an account name or an account name and PUID.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   body: JObject (required)
  ##       : Parameters describing the name to check availability for.
  var path_593944 = newJObject()
  var query_593946 = newJObject()
  var body_593947 = newJObject()
  add(query_593946, "api-version", newJString(apiVersion))
  add(path_593944, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_593947 = body
  result = call_593943.call(path_593944, query_593946, nil, nil, body_593947)

var accountsCheckNameAvailability* = Call_AccountsCheckNameAvailability_593859(
    name: "accountsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/microsoft.visualstudio/checkNameAvailability",
    validator: validate_AccountsCheckNameAvailability_593860, base: "",
    url: url_AccountsCheckNameAvailability_593861, schemes: {Scheme.Https})
type
  Call_ProjectListByAccountResource_593949 = ref object of OpenApiRestCall_593408
proc url_ProjectListByAccountResource_593951(protocol: Scheme; host: string;
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

proc validate_ProjectListByAccountResource_593950(path: JsonNode; query: JsonNode;
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
  var valid_593952 = path.getOrDefault("resourceGroupName")
  valid_593952 = validateParameter(valid_593952, JString, required = true,
                                 default = nil)
  if valid_593952 != nil:
    section.add "resourceGroupName", valid_593952
  var valid_593953 = path.getOrDefault("subscriptionId")
  valid_593953 = validateParameter(valid_593953, JString, required = true,
                                 default = nil)
  if valid_593953 != nil:
    section.add "subscriptionId", valid_593953
  var valid_593954 = path.getOrDefault("rootResourceName")
  valid_593954 = validateParameter(valid_593954, JString, required = true,
                                 default = nil)
  if valid_593954 != nil:
    section.add "rootResourceName", valid_593954
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593955 = query.getOrDefault("api-version")
  valid_593955 = validateParameter(valid_593955, JString, required = true,
                                 default = nil)
  if valid_593955 != nil:
    section.add "api-version", valid_593955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593956: Call_ProjectListByAccountResource_593949; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Visual Studio Team Services project resources created in the specified Team Services account.
  ## 
  let valid = call_593956.validator(path, query, header, formData, body)
  let scheme = call_593956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593956.url(scheme.get, call_593956.host, call_593956.base,
                         call_593956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593956, url, valid)

proc call*(call_593957: Call_ProjectListByAccountResource_593949;
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
  var path_593958 = newJObject()
  var query_593959 = newJObject()
  add(path_593958, "resourceGroupName", newJString(resourceGroupName))
  add(query_593959, "api-version", newJString(apiVersion))
  add(path_593958, "subscriptionId", newJString(subscriptionId))
  add(path_593958, "rootResourceName", newJString(rootResourceName))
  result = call_593957.call(path_593958, query_593959, nil, nil, nil)

var projectListByAccountResource* = Call_ProjectListByAccountResource_593949(
    name: "projectListByAccountResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project",
    validator: validate_ProjectListByAccountResource_593950, base: "",
    url: url_ProjectListByAccountResource_593951, schemes: {Scheme.Https})
type
  Call_ProjectsCreate_593972 = ref object of OpenApiRestCall_593408
proc url_ProjectsCreate_593974(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsCreate_593973(path: JsonNode; query: JsonNode;
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
  var valid_593975 = path.getOrDefault("resourceGroupName")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "resourceGroupName", valid_593975
  var valid_593976 = path.getOrDefault("subscriptionId")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "subscriptionId", valid_593976
  var valid_593977 = path.getOrDefault("resourceName")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "resourceName", valid_593977
  var valid_593978 = path.getOrDefault("rootResourceName")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "rootResourceName", valid_593978
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   validating: JString
  ##             : This parameter is ignored and should be set to an empty string.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593979 = query.getOrDefault("api-version")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "api-version", valid_593979
  var valid_593980 = query.getOrDefault("validating")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "validating", valid_593980
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

proc call*(call_593982: Call_ProjectsCreate_593972; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Team Services project in the collection with the specified name. 'VersionControlOption' and 'ProcessTemplateId' must be specified in the resource properties. Valid values for VersionControlOption: Git, Tfvc. Valid values for ProcessTemplateId: 6B724908-EF14-45CF-84F8-768B5384DA45, ADCC42AB-9882-485E-A3ED-7678F01F66BC, 27450541-8E31-4150-9947-DC59F998FC01 (these IDs correspond to Scrum, Agile, and CMMI process templates).
  ## 
  let valid = call_593982.validator(path, query, header, formData, body)
  let scheme = call_593982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593982.url(scheme.get, call_593982.host, call_593982.base,
                         call_593982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593982, url, valid)

proc call*(call_593983: Call_ProjectsCreate_593972; resourceGroupName: string;
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
  var path_593984 = newJObject()
  var query_593985 = newJObject()
  var body_593986 = newJObject()
  add(path_593984, "resourceGroupName", newJString(resourceGroupName))
  add(query_593985, "api-version", newJString(apiVersion))
  add(path_593984, "subscriptionId", newJString(subscriptionId))
  add(path_593984, "resourceName", newJString(resourceName))
  add(query_593985, "validating", newJString(validating))
  if body != nil:
    body_593986 = body
  add(path_593984, "rootResourceName", newJString(rootResourceName))
  result = call_593983.call(path_593984, query_593985, nil, nil, body_593986)

var projectsCreate* = Call_ProjectsCreate_593972(name: "projectsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project/{resourceName}",
    validator: validate_ProjectsCreate_593973, base: "", url: url_ProjectsCreate_593974,
    schemes: {Scheme.Https})
type
  Call_ProjectsGet_593960 = ref object of OpenApiRestCall_593408
proc url_ProjectsGet_593962(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsGet_593961(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593963 = path.getOrDefault("resourceGroupName")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "resourceGroupName", valid_593963
  var valid_593964 = path.getOrDefault("subscriptionId")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "subscriptionId", valid_593964
  var valid_593965 = path.getOrDefault("resourceName")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "resourceName", valid_593965
  var valid_593966 = path.getOrDefault("rootResourceName")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "rootResourceName", valid_593966
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593967 = query.getOrDefault("api-version")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "api-version", valid_593967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593968: Call_ProjectsGet_593960; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a Team Services project resource.
  ## 
  let valid = call_593968.validator(path, query, header, formData, body)
  let scheme = call_593968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593968.url(scheme.get, call_593968.host, call_593968.base,
                         call_593968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593968, url, valid)

proc call*(call_593969: Call_ProjectsGet_593960; resourceGroupName: string;
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
  var path_593970 = newJObject()
  var query_593971 = newJObject()
  add(path_593970, "resourceGroupName", newJString(resourceGroupName))
  add(query_593971, "api-version", newJString(apiVersion))
  add(path_593970, "subscriptionId", newJString(subscriptionId))
  add(path_593970, "resourceName", newJString(resourceName))
  add(path_593970, "rootResourceName", newJString(rootResourceName))
  result = call_593969.call(path_593970, query_593971, nil, nil, nil)

var projectsGet* = Call_ProjectsGet_593960(name: "projectsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project/{resourceName}",
                                        validator: validate_ProjectsGet_593961,
                                        base: "", url: url_ProjectsGet_593962,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsUpdate_593987 = ref object of OpenApiRestCall_593408
proc url_ProjectsUpdate_593989(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsUpdate_593988(path: JsonNode; query: JsonNode;
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
  var valid_593990 = path.getOrDefault("resourceGroupName")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "resourceGroupName", valid_593990
  var valid_593991 = path.getOrDefault("subscriptionId")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "subscriptionId", valid_593991
  var valid_593992 = path.getOrDefault("resourceName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "resourceName", valid_593992
  var valid_593993 = path.getOrDefault("rootResourceName")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "rootResourceName", valid_593993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593994 = query.getOrDefault("api-version")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "api-version", valid_593994
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

proc call*(call_593996: Call_ProjectsUpdate_593987; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tags of the specified Team Services project.
  ## 
  let valid = call_593996.validator(path, query, header, formData, body)
  let scheme = call_593996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593996.url(scheme.get, call_593996.host, call_593996.base,
                         call_593996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593996, url, valid)

proc call*(call_593997: Call_ProjectsUpdate_593987; resourceGroupName: string;
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
  var path_593998 = newJObject()
  var query_593999 = newJObject()
  var body_594000 = newJObject()
  add(path_593998, "resourceGroupName", newJString(resourceGroupName))
  add(query_593999, "api-version", newJString(apiVersion))
  add(path_593998, "subscriptionId", newJString(subscriptionId))
  add(path_593998, "resourceName", newJString(resourceName))
  if body != nil:
    body_594000 = body
  add(path_593998, "rootResourceName", newJString(rootResourceName))
  result = call_593997.call(path_593998, query_593999, nil, nil, body_594000)

var projectsUpdate* = Call_ProjectsUpdate_593987(name: "projectsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project/{resourceName}",
    validator: validate_ProjectsUpdate_593988, base: "", url: url_ProjectsUpdate_593989,
    schemes: {Scheme.Https})
type
  Call_AccountsListByResourceGroup_594001 = ref object of OpenApiRestCall_593408
proc url_AccountsListByResourceGroup_594003(protocol: Scheme; host: string;
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

proc validate_AccountsListByResourceGroup_594002(path: JsonNode; query: JsonNode;
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
  var valid_594004 = path.getOrDefault("resourceGroupName")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "resourceGroupName", valid_594004
  var valid_594005 = path.getOrDefault("subscriptionId")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "subscriptionId", valid_594005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594006 = query.getOrDefault("api-version")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "api-version", valid_594006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594007: Call_AccountsListByResourceGroup_594001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Visual Studio Team Services account resources under the resource group linked to the specified Azure subscription.
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_AccountsListByResourceGroup_594001;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## accountsListByResourceGroup
  ## Gets all Visual Studio Team Services account resources under the resource group linked to the specified Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  var path_594009 = newJObject()
  var query_594010 = newJObject()
  add(path_594009, "resourceGroupName", newJString(resourceGroupName))
  add(query_594010, "api-version", newJString(apiVersion))
  add(path_594009, "subscriptionId", newJString(subscriptionId))
  result = call_594008.call(path_594009, query_594010, nil, nil, nil)

var accountsListByResourceGroup* = Call_AccountsListByResourceGroup_594001(
    name: "accountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account",
    validator: validate_AccountsListByResourceGroup_594002, base: "",
    url: url_AccountsListByResourceGroup_594003, schemes: {Scheme.Https})
type
  Call_ExtensionsListByAccount_594011 = ref object of OpenApiRestCall_593408
proc url_ExtensionsListByAccount_594013(protocol: Scheme; host: string; base: string;
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

proc validate_ExtensionsListByAccount_594012(path: JsonNode; query: JsonNode;
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
  var valid_594014 = path.getOrDefault("resourceGroupName")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "resourceGroupName", valid_594014
  var valid_594015 = path.getOrDefault("subscriptionId")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "subscriptionId", valid_594015
  var valid_594016 = path.getOrDefault("accountResourceName")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "accountResourceName", valid_594016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594017 = query.getOrDefault("api-version")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "api-version", valid_594017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594018: Call_ExtensionsListByAccount_594011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the extension resources created within the resource group.
  ## 
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_ExtensionsListByAccount_594011;
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
  var path_594020 = newJObject()
  var query_594021 = newJObject()
  add(path_594020, "resourceGroupName", newJString(resourceGroupName))
  add(query_594021, "api-version", newJString(apiVersion))
  add(path_594020, "subscriptionId", newJString(subscriptionId))
  add(path_594020, "accountResourceName", newJString(accountResourceName))
  result = call_594019.call(path_594020, query_594021, nil, nil, nil)

var extensionsListByAccount* = Call_ExtensionsListByAccount_594011(
    name: "extensionsListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension",
    validator: validate_ExtensionsListByAccount_594012, base: "",
    url: url_ExtensionsListByAccount_594013, schemes: {Scheme.Https})
type
  Call_ExtensionsCreate_594034 = ref object of OpenApiRestCall_593408
proc url_ExtensionsCreate_594036(protocol: Scheme; host: string; base: string;
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

proc validate_ExtensionsCreate_594035(path: JsonNode; query: JsonNode;
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
  var valid_594037 = path.getOrDefault("resourceGroupName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "resourceGroupName", valid_594037
  var valid_594038 = path.getOrDefault("subscriptionId")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "subscriptionId", valid_594038
  var valid_594039 = path.getOrDefault("extensionResourceName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "extensionResourceName", valid_594039
  var valid_594040 = path.getOrDefault("accountResourceName")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "accountResourceName", valid_594040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594041 = query.getOrDefault("api-version")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "api-version", valid_594041
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

proc call*(call_594043: Call_ExtensionsCreate_594034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers the extension with a Visual Studio Team Services account.
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_ExtensionsCreate_594034; resourceGroupName: string;
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
  var path_594045 = newJObject()
  var query_594046 = newJObject()
  var body_594047 = newJObject()
  add(path_594045, "resourceGroupName", newJString(resourceGroupName))
  add(query_594046, "api-version", newJString(apiVersion))
  add(path_594045, "subscriptionId", newJString(subscriptionId))
  add(path_594045, "extensionResourceName", newJString(extensionResourceName))
  add(path_594045, "accountResourceName", newJString(accountResourceName))
  if body != nil:
    body_594047 = body
  result = call_594044.call(path_594045, query_594046, nil, nil, body_594047)

var extensionsCreate* = Call_ExtensionsCreate_594034(name: "extensionsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension/{extensionResourceName}",
    validator: validate_ExtensionsCreate_594035, base: "",
    url: url_ExtensionsCreate_594036, schemes: {Scheme.Https})
type
  Call_ExtensionsGet_594022 = ref object of OpenApiRestCall_593408
proc url_ExtensionsGet_594024(protocol: Scheme; host: string; base: string;
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

proc validate_ExtensionsGet_594023(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594025 = path.getOrDefault("resourceGroupName")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "resourceGroupName", valid_594025
  var valid_594026 = path.getOrDefault("subscriptionId")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "subscriptionId", valid_594026
  var valid_594027 = path.getOrDefault("extensionResourceName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "extensionResourceName", valid_594027
  var valid_594028 = path.getOrDefault("accountResourceName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "accountResourceName", valid_594028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594029 = query.getOrDefault("api-version")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "api-version", valid_594029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594030: Call_ExtensionsGet_594022; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an extension associated with a Visual Studio Team Services account resource.
  ## 
  let valid = call_594030.validator(path, query, header, formData, body)
  let scheme = call_594030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594030.url(scheme.get, call_594030.host, call_594030.base,
                         call_594030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594030, url, valid)

proc call*(call_594031: Call_ExtensionsGet_594022; resourceGroupName: string;
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
  var path_594032 = newJObject()
  var query_594033 = newJObject()
  add(path_594032, "resourceGroupName", newJString(resourceGroupName))
  add(query_594033, "api-version", newJString(apiVersion))
  add(path_594032, "subscriptionId", newJString(subscriptionId))
  add(path_594032, "extensionResourceName", newJString(extensionResourceName))
  add(path_594032, "accountResourceName", newJString(accountResourceName))
  result = call_594031.call(path_594032, query_594033, nil, nil, nil)

var extensionsGet* = Call_ExtensionsGet_594022(name: "extensionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension/{extensionResourceName}",
    validator: validate_ExtensionsGet_594023, base: "", url: url_ExtensionsGet_594024,
    schemes: {Scheme.Https})
type
  Call_ExtensionsUpdate_594060 = ref object of OpenApiRestCall_593408
proc url_ExtensionsUpdate_594062(protocol: Scheme; host: string; base: string;
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

proc validate_ExtensionsUpdate_594061(path: JsonNode; query: JsonNode;
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
  var valid_594063 = path.getOrDefault("resourceGroupName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "resourceGroupName", valid_594063
  var valid_594064 = path.getOrDefault("subscriptionId")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "subscriptionId", valid_594064
  var valid_594065 = path.getOrDefault("extensionResourceName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "extensionResourceName", valid_594065
  var valid_594066 = path.getOrDefault("accountResourceName")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "accountResourceName", valid_594066
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594067 = query.getOrDefault("api-version")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "api-version", valid_594067
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

proc call*(call_594069: Call_ExtensionsUpdate_594060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing extension registration for the Visual Studio Team Services account.
  ## 
  let valid = call_594069.validator(path, query, header, formData, body)
  let scheme = call_594069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594069.url(scheme.get, call_594069.host, call_594069.base,
                         call_594069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594069, url, valid)

proc call*(call_594070: Call_ExtensionsUpdate_594060; resourceGroupName: string;
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
  var path_594071 = newJObject()
  var query_594072 = newJObject()
  var body_594073 = newJObject()
  add(path_594071, "resourceGroupName", newJString(resourceGroupName))
  add(query_594072, "api-version", newJString(apiVersion))
  add(path_594071, "subscriptionId", newJString(subscriptionId))
  add(path_594071, "extensionResourceName", newJString(extensionResourceName))
  add(path_594071, "accountResourceName", newJString(accountResourceName))
  if body != nil:
    body_594073 = body
  result = call_594070.call(path_594071, query_594072, nil, nil, body_594073)

var extensionsUpdate* = Call_ExtensionsUpdate_594060(name: "extensionsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension/{extensionResourceName}",
    validator: validate_ExtensionsUpdate_594061, base: "",
    url: url_ExtensionsUpdate_594062, schemes: {Scheme.Https})
type
  Call_ExtensionsDelete_594048 = ref object of OpenApiRestCall_593408
proc url_ExtensionsDelete_594050(protocol: Scheme; host: string; base: string;
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

proc validate_ExtensionsDelete_594049(path: JsonNode; query: JsonNode;
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
  var valid_594051 = path.getOrDefault("resourceGroupName")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "resourceGroupName", valid_594051
  var valid_594052 = path.getOrDefault("subscriptionId")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "subscriptionId", valid_594052
  var valid_594053 = path.getOrDefault("extensionResourceName")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "extensionResourceName", valid_594053
  var valid_594054 = path.getOrDefault("accountResourceName")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "accountResourceName", valid_594054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594055 = query.getOrDefault("api-version")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "api-version", valid_594055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594056: Call_ExtensionsDelete_594048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes an extension resource registration for a Visual Studio Team Services account.
  ## 
  let valid = call_594056.validator(path, query, header, formData, body)
  let scheme = call_594056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594056.url(scheme.get, call_594056.host, call_594056.base,
                         call_594056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594056, url, valid)

proc call*(call_594057: Call_ExtensionsDelete_594048; resourceGroupName: string;
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
  var path_594058 = newJObject()
  var query_594059 = newJObject()
  add(path_594058, "resourceGroupName", newJString(resourceGroupName))
  add(query_594059, "api-version", newJString(apiVersion))
  add(path_594058, "subscriptionId", newJString(subscriptionId))
  add(path_594058, "extensionResourceName", newJString(extensionResourceName))
  add(path_594058, "accountResourceName", newJString(accountResourceName))
  result = call_594057.call(path_594058, query_594059, nil, nil, nil)

var extensionsDelete* = Call_ExtensionsDelete_594048(name: "extensionsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{accountResourceName}/extension/{extensionResourceName}",
    validator: validate_ExtensionsDelete_594049, base: "",
    url: url_ExtensionsDelete_594050, schemes: {Scheme.Https})
type
  Call_AccountsCreateOrUpdate_594085 = ref object of OpenApiRestCall_593408
proc url_AccountsCreateOrUpdate_594087(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsCreateOrUpdate_594086(path: JsonNode; query: JsonNode;
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
  var valid_594088 = path.getOrDefault("resourceGroupName")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "resourceGroupName", valid_594088
  var valid_594089 = path.getOrDefault("subscriptionId")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "subscriptionId", valid_594089
  var valid_594090 = path.getOrDefault("resourceName")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "resourceName", valid_594090
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594091 = query.getOrDefault("api-version")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "api-version", valid_594091
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

proc call*(call_594093: Call_AccountsCreateOrUpdate_594085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Visual Studio Team Services account resource.
  ## 
  let valid = call_594093.validator(path, query, header, formData, body)
  let scheme = call_594093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594093.url(scheme.get, call_594093.host, call_594093.base,
                         call_594093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594093, url, valid)

proc call*(call_594094: Call_AccountsCreateOrUpdate_594085;
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
  var path_594095 = newJObject()
  var query_594096 = newJObject()
  var body_594097 = newJObject()
  add(path_594095, "resourceGroupName", newJString(resourceGroupName))
  add(query_594096, "api-version", newJString(apiVersion))
  add(path_594095, "subscriptionId", newJString(subscriptionId))
  add(path_594095, "resourceName", newJString(resourceName))
  if body != nil:
    body_594097 = body
  result = call_594094.call(path_594095, query_594096, nil, nil, body_594097)

var accountsCreateOrUpdate* = Call_AccountsCreateOrUpdate_594085(
    name: "accountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{resourceName}",
    validator: validate_AccountsCreateOrUpdate_594086, base: "",
    url: url_AccountsCreateOrUpdate_594087, schemes: {Scheme.Https})
type
  Call_AccountsGet_594074 = ref object of OpenApiRestCall_593408
proc url_AccountsGet_594076(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsGet_594075(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594077 = path.getOrDefault("resourceGroupName")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "resourceGroupName", valid_594077
  var valid_594078 = path.getOrDefault("subscriptionId")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "subscriptionId", valid_594078
  var valid_594079 = path.getOrDefault("resourceName")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "resourceName", valid_594079
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594080 = query.getOrDefault("api-version")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "api-version", valid_594080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594081: Call_AccountsGet_594074; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Visual Studio Team Services account resource details.
  ## 
  let valid = call_594081.validator(path, query, header, formData, body)
  let scheme = call_594081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594081.url(scheme.get, call_594081.host, call_594081.base,
                         call_594081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594081, url, valid)

proc call*(call_594082: Call_AccountsGet_594074; resourceGroupName: string;
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
  var path_594083 = newJObject()
  var query_594084 = newJObject()
  add(path_594083, "resourceGroupName", newJString(resourceGroupName))
  add(query_594084, "api-version", newJString(apiVersion))
  add(path_594083, "subscriptionId", newJString(subscriptionId))
  add(path_594083, "resourceName", newJString(resourceName))
  result = call_594082.call(path_594083, query_594084, nil, nil, nil)

var accountsGet* = Call_AccountsGet_594074(name: "accountsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{resourceName}",
                                        validator: validate_AccountsGet_594075,
                                        base: "", url: url_AccountsGet_594076,
                                        schemes: {Scheme.Https})
type
  Call_AccountsDelete_594098 = ref object of OpenApiRestCall_593408
proc url_AccountsDelete_594100(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsDelete_594099(path: JsonNode; query: JsonNode;
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
  var valid_594101 = path.getOrDefault("resourceGroupName")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "resourceGroupName", valid_594101
  var valid_594102 = path.getOrDefault("subscriptionId")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "subscriptionId", valid_594102
  var valid_594103 = path.getOrDefault("resourceName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "resourceName", valid_594103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594104 = query.getOrDefault("api-version")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "api-version", valid_594104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594105: Call_AccountsDelete_594098; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Visual Studio Team Services account resource.
  ## 
  let valid = call_594105.validator(path, query, header, formData, body)
  let scheme = call_594105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594105.url(scheme.get, call_594105.host, call_594105.base,
                         call_594105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594105, url, valid)

proc call*(call_594106: Call_AccountsDelete_594098; resourceGroupName: string;
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
  var path_594107 = newJObject()
  var query_594108 = newJObject()
  add(path_594107, "resourceGroupName", newJString(resourceGroupName))
  add(query_594108, "api-version", newJString(apiVersion))
  add(path_594107, "subscriptionId", newJString(subscriptionId))
  add(path_594107, "resourceName", newJString(resourceName))
  result = call_594106.call(path_594107, query_594108, nil, nil, nil)

var accountsDelete* = Call_AccountsDelete_594098(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{resourceName}",
    validator: validate_AccountsDelete_594099, base: "", url: url_AccountsDelete_594100,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
