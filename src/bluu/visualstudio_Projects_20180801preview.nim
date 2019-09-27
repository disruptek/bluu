
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Visual Studio Projects Resource Provider Client
## version: 2018-08-01-preview
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

  OpenApiRestCall_593409 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593409](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593409): Option[Scheme] {.used.} =
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
  macServiceName = "visualstudio-Projects"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProjectsListByAccountResource_593631 = ref object of OpenApiRestCall_593409
proc url_ProjectsListByAccountResource_593633(protocol: Scheme; host: string;
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

proc validate_ProjectsListByAccountResource_593632(path: JsonNode; query: JsonNode;
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
  var valid_593806 = path.getOrDefault("resourceGroupName")
  valid_593806 = validateParameter(valid_593806, JString, required = true,
                                 default = nil)
  if valid_593806 != nil:
    section.add "resourceGroupName", valid_593806
  var valid_593807 = path.getOrDefault("subscriptionId")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "subscriptionId", valid_593807
  var valid_593808 = path.getOrDefault("rootResourceName")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "rootResourceName", valid_593808
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593809 = query.getOrDefault("api-version")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "api-version", valid_593809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593832: Call_ProjectsListByAccountResource_593631; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Visual Studio Team Services project resources created in the specified Team Services account.
  ## 
  let valid = call_593832.validator(path, query, header, formData, body)
  let scheme = call_593832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593832.url(scheme.get, call_593832.host, call_593832.base,
                         call_593832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593832, url, valid)

proc call*(call_593903: Call_ProjectsListByAccountResource_593631;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          rootResourceName: string): Recallable =
  ## projectsListByAccountResource
  ## Gets all Visual Studio Team Services project resources created in the specified Team Services account.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription identifier.
  ##   rootResourceName: string (required)
  ##                   : Name of the Team Services account.
  var path_593904 = newJObject()
  var query_593906 = newJObject()
  add(path_593904, "resourceGroupName", newJString(resourceGroupName))
  add(query_593906, "api-version", newJString(apiVersion))
  add(path_593904, "subscriptionId", newJString(subscriptionId))
  add(path_593904, "rootResourceName", newJString(rootResourceName))
  result = call_593903.call(path_593904, query_593906, nil, nil, nil)

var projectsListByAccountResource* = Call_ProjectsListByAccountResource_593631(
    name: "projectsListByAccountResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project",
    validator: validate_ProjectsListByAccountResource_593632, base: "",
    url: url_ProjectsListByAccountResource_593633, schemes: {Scheme.Https})
type
  Call_ProjectsCreateOrUpdate_593957 = ref object of OpenApiRestCall_593409
proc url_ProjectsCreateOrUpdate_593959(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsCreateOrUpdate_593958(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Team Services project in the collection with the specified name. 'VersionControlOption' and 'ProcessTemplateId' must be specified in the resource properties. Valid values for VersionControlOption: Git, Tfvc. Valid values for ProcessTemplateId: 6B724908-EF14-45CF-84F8-768B5384DA45, ADCC42AB-9882-485E-A3ED-7678F01F66BC, 27450541-8E31-4150-9947-DC59F998FC01 (these IDs correspond to Scrum, Agile, and CMMI process templates).
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
  var valid_593960 = path.getOrDefault("resourceGroupName")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "resourceGroupName", valid_593960
  var valid_593961 = path.getOrDefault("subscriptionId")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "subscriptionId", valid_593961
  var valid_593962 = path.getOrDefault("resourceName")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "resourceName", valid_593962
  var valid_593963 = path.getOrDefault("rootResourceName")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "rootResourceName", valid_593963
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   validating: JString
  ##             : This parameter is ignored and should be set to an empty string.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593964 = query.getOrDefault("api-version")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "api-version", valid_593964
  var valid_593965 = query.getOrDefault("validating")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "validating", valid_593965
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

proc call*(call_593967: Call_ProjectsCreateOrUpdate_593957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Team Services project in the collection with the specified name. 'VersionControlOption' and 'ProcessTemplateId' must be specified in the resource properties. Valid values for VersionControlOption: Git, Tfvc. Valid values for ProcessTemplateId: 6B724908-EF14-45CF-84F8-768B5384DA45, ADCC42AB-9882-485E-A3ED-7678F01F66BC, 27450541-8E31-4150-9947-DC59F998FC01 (these IDs correspond to Scrum, Agile, and CMMI process templates).
  ## 
  let valid = call_593967.validator(path, query, header, formData, body)
  let scheme = call_593967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593967.url(scheme.get, call_593967.host, call_593967.base,
                         call_593967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593967, url, valid)

proc call*(call_593968: Call_ProjectsCreateOrUpdate_593957;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; body: JsonNode; rootResourceName: string;
          validating: string = ""): Recallable =
  ## projectsCreateOrUpdate
  ## Creates or updates a Team Services project in the collection with the specified name. 'VersionControlOption' and 'ProcessTemplateId' must be specified in the resource properties. Valid values for VersionControlOption: Git, Tfvc. Valid values for ProcessTemplateId: 6B724908-EF14-45CF-84F8-768B5384DA45, ADCC42AB-9882-485E-A3ED-7678F01F66BC, 27450541-8E31-4150-9947-DC59F998FC01 (these IDs correspond to Scrum, Agile, and CMMI process templates).
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
  var path_593969 = newJObject()
  var query_593970 = newJObject()
  var body_593971 = newJObject()
  add(path_593969, "resourceGroupName", newJString(resourceGroupName))
  add(query_593970, "api-version", newJString(apiVersion))
  add(path_593969, "subscriptionId", newJString(subscriptionId))
  add(path_593969, "resourceName", newJString(resourceName))
  add(query_593970, "validating", newJString(validating))
  if body != nil:
    body_593971 = body
  add(path_593969, "rootResourceName", newJString(rootResourceName))
  result = call_593968.call(path_593969, query_593970, nil, nil, body_593971)

var projectsCreateOrUpdate* = Call_ProjectsCreateOrUpdate_593957(
    name: "projectsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project/{resourceName}",
    validator: validate_ProjectsCreateOrUpdate_593958, base: "",
    url: url_ProjectsCreateOrUpdate_593959, schemes: {Scheme.Https})
type
  Call_ProjectsGet_593945 = ref object of OpenApiRestCall_593409
proc url_ProjectsGet_593947(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsGet_593946(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593948 = path.getOrDefault("resourceGroupName")
  valid_593948 = validateParameter(valid_593948, JString, required = true,
                                 default = nil)
  if valid_593948 != nil:
    section.add "resourceGroupName", valid_593948
  var valid_593949 = path.getOrDefault("subscriptionId")
  valid_593949 = validateParameter(valid_593949, JString, required = true,
                                 default = nil)
  if valid_593949 != nil:
    section.add "subscriptionId", valid_593949
  var valid_593950 = path.getOrDefault("resourceName")
  valid_593950 = validateParameter(valid_593950, JString, required = true,
                                 default = nil)
  if valid_593950 != nil:
    section.add "resourceName", valid_593950
  var valid_593951 = path.getOrDefault("rootResourceName")
  valid_593951 = validateParameter(valid_593951, JString, required = true,
                                 default = nil)
  if valid_593951 != nil:
    section.add "rootResourceName", valid_593951
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593952 = query.getOrDefault("api-version")
  valid_593952 = validateParameter(valid_593952, JString, required = true,
                                 default = nil)
  if valid_593952 != nil:
    section.add "api-version", valid_593952
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593953: Call_ProjectsGet_593945; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a Team Services project resource.
  ## 
  let valid = call_593953.validator(path, query, header, formData, body)
  let scheme = call_593953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593953.url(scheme.get, call_593953.host, call_593953.base,
                         call_593953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593953, url, valid)

proc call*(call_593954: Call_ProjectsGet_593945; resourceGroupName: string;
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
  var path_593955 = newJObject()
  var query_593956 = newJObject()
  add(path_593955, "resourceGroupName", newJString(resourceGroupName))
  add(query_593956, "api-version", newJString(apiVersion))
  add(path_593955, "subscriptionId", newJString(subscriptionId))
  add(path_593955, "resourceName", newJString(resourceName))
  add(path_593955, "rootResourceName", newJString(rootResourceName))
  result = call_593954.call(path_593955, query_593956, nil, nil, nil)

var projectsGet* = Call_ProjectsGet_593945(name: "projectsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project/{resourceName}",
                                        validator: validate_ProjectsGet_593946,
                                        base: "", url: url_ProjectsGet_593947,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsUpdate_593972 = ref object of OpenApiRestCall_593409
proc url_ProjectsUpdate_593974(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsUpdate_593973(path: JsonNode; query: JsonNode;
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593979 = query.getOrDefault("api-version")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "api-version", valid_593979
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

proc call*(call_593981: Call_ProjectsUpdate_593972; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the tags of the specified Team Services project.
  ## 
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_ProjectsUpdate_593972; resourceGroupName: string;
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
  var path_593983 = newJObject()
  var query_593984 = newJObject()
  var body_593985 = newJObject()
  add(path_593983, "resourceGroupName", newJString(resourceGroupName))
  add(query_593984, "api-version", newJString(apiVersion))
  add(path_593983, "subscriptionId", newJString(subscriptionId))
  add(path_593983, "resourceName", newJString(resourceName))
  if body != nil:
    body_593985 = body
  add(path_593983, "rootResourceName", newJString(rootResourceName))
  result = call_593982.call(path_593983, query_593984, nil, nil, body_593985)

var projectsUpdate* = Call_ProjectsUpdate_593972(name: "projectsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.visualstudio/account/{rootResourceName}/project/{resourceName}",
    validator: validate_ProjectsUpdate_593973, base: "", url: url_ProjectsUpdate_593974,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
