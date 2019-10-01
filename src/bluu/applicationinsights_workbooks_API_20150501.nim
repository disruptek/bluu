
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApplicationInsightsManagementClient
## version: 2015-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Application Insights workbook type.
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

  OpenApiRestCall_596458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596458): Option[Scheme] {.used.} =
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
  macServiceName = "applicationinsights-workbooks_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_WorkbooksListByResourceGroup_596680 = ref object of OpenApiRestCall_596458
proc url_WorkbooksListByResourceGroup_596682(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/resourceGroup/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/workbooks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkbooksListByResourceGroup_596681(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all Workbooks defined within a specified resource group and category.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596855 = path.getOrDefault("resourceGroupName")
  valid_596855 = validateParameter(valid_596855, JString, required = true,
                                 default = nil)
  if valid_596855 != nil:
    section.add "resourceGroupName", valid_596855
  var valid_596856 = path.getOrDefault("subscriptionId")
  valid_596856 = validateParameter(valid_596856, JString, required = true,
                                 default = nil)
  if valid_596856 != nil:
    section.add "subscriptionId", valid_596856
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   tags: JArray
  ##       : Tags presents on each workbook returned.
  ##   category: JString (required)
  ##           : Category of workbook to return.
  ##   canFetchContent: JBool
  ##                  : Flag indicating whether or not to return the full content for each applicable workbook. If false, only return summary content for workbooks.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596857 = query.getOrDefault("api-version")
  valid_596857 = validateParameter(valid_596857, JString, required = true,
                                 default = nil)
  if valid_596857 != nil:
    section.add "api-version", valid_596857
  var valid_596858 = query.getOrDefault("tags")
  valid_596858 = validateParameter(valid_596858, JArray, required = false,
                                 default = nil)
  if valid_596858 != nil:
    section.add "tags", valid_596858
  var valid_596872 = query.getOrDefault("category")
  valid_596872 = validateParameter(valid_596872, JString, required = true,
                                 default = newJString("workbook"))
  if valid_596872 != nil:
    section.add "category", valid_596872
  var valid_596873 = query.getOrDefault("canFetchContent")
  valid_596873 = validateParameter(valid_596873, JBool, required = false, default = nil)
  if valid_596873 != nil:
    section.add "canFetchContent", valid_596873
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596896: Call_WorkbooksListByResourceGroup_596680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Workbooks defined within a specified resource group and category.
  ## 
  let valid = call_596896.validator(path, query, header, formData, body)
  let scheme = call_596896.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596896.url(scheme.get, call_596896.host, call_596896.base,
                         call_596896.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596896, url, valid)

proc call*(call_596967: Call_WorkbooksListByResourceGroup_596680;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          tags: JsonNode = nil; category: string = "workbook";
          canFetchContent: bool = false): Recallable =
  ## workbooksListByResourceGroup
  ## Get all Workbooks defined within a specified resource group and category.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   tags: JArray
  ##       : Tags presents on each workbook returned.
  ##   category: string (required)
  ##           : Category of workbook to return.
  ##   canFetchContent: bool
  ##                  : Flag indicating whether or not to return the full content for each applicable workbook. If false, only return summary content for workbooks.
  var path_596968 = newJObject()
  var query_596970 = newJObject()
  add(path_596968, "resourceGroupName", newJString(resourceGroupName))
  add(query_596970, "api-version", newJString(apiVersion))
  add(path_596968, "subscriptionId", newJString(subscriptionId))
  if tags != nil:
    query_596970.add "tags", tags
  add(query_596970, "category", newJString(category))
  add(query_596970, "canFetchContent", newJBool(canFetchContent))
  result = call_596967.call(path_596968, query_596970, nil, nil, nil)

var workbooksListByResourceGroup* = Call_WorkbooksListByResourceGroup_596680(
    name: "workbooksListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/microsoft.insights/workbooks",
    validator: validate_WorkbooksListByResourceGroup_596681, base: "",
    url: url_WorkbooksListByResourceGroup_596682, schemes: {Scheme.Https})
type
  Call_WorkbooksCreateOrUpdate_597020 = ref object of OpenApiRestCall_596458
proc url_WorkbooksCreateOrUpdate_597022(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/resourceGroup/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/workbooks/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkbooksCreateOrUpdate_597021(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new workbook.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597040 = path.getOrDefault("resourceGroupName")
  valid_597040 = validateParameter(valid_597040, JString, required = true,
                                 default = nil)
  if valid_597040 != nil:
    section.add "resourceGroupName", valid_597040
  var valid_597041 = path.getOrDefault("subscriptionId")
  valid_597041 = validateParameter(valid_597041, JString, required = true,
                                 default = nil)
  if valid_597041 != nil:
    section.add "subscriptionId", valid_597041
  var valid_597042 = path.getOrDefault("resourceName")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "resourceName", valid_597042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597043 = query.getOrDefault("api-version")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "api-version", valid_597043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   workbookProperties: JObject (required)
  ##                     : Properties that need to be specified to create a new workbook.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597045: Call_WorkbooksCreateOrUpdate_597020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new workbook.
  ## 
  let valid = call_597045.validator(path, query, header, formData, body)
  let scheme = call_597045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597045.url(scheme.get, call_597045.host, call_597045.base,
                         call_597045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597045, url, valid)

proc call*(call_597046: Call_WorkbooksCreateOrUpdate_597020;
          resourceGroupName: string; workbookProperties: JsonNode;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## workbooksCreateOrUpdate
  ## Create a new workbook.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   workbookProperties: JObject (required)
  ##                     : Properties that need to be specified to create a new workbook.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_597047 = newJObject()
  var query_597048 = newJObject()
  var body_597049 = newJObject()
  add(path_597047, "resourceGroupName", newJString(resourceGroupName))
  if workbookProperties != nil:
    body_597049 = workbookProperties
  add(query_597048, "api-version", newJString(apiVersion))
  add(path_597047, "subscriptionId", newJString(subscriptionId))
  add(path_597047, "resourceName", newJString(resourceName))
  result = call_597046.call(path_597047, query_597048, nil, nil, body_597049)

var workbooksCreateOrUpdate* = Call_WorkbooksCreateOrUpdate_597020(
    name: "workbooksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/microsoft.insights/workbooks/{resourceName}",
    validator: validate_WorkbooksCreateOrUpdate_597021, base: "",
    url: url_WorkbooksCreateOrUpdate_597022, schemes: {Scheme.Https})
type
  Call_WorkbooksGet_597009 = ref object of OpenApiRestCall_596458
proc url_WorkbooksGet_597011(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/resourceGroup/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/workbooks/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkbooksGet_597010(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single workbook by its resourceName.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597012 = path.getOrDefault("resourceGroupName")
  valid_597012 = validateParameter(valid_597012, JString, required = true,
                                 default = nil)
  if valid_597012 != nil:
    section.add "resourceGroupName", valid_597012
  var valid_597013 = path.getOrDefault("subscriptionId")
  valid_597013 = validateParameter(valid_597013, JString, required = true,
                                 default = nil)
  if valid_597013 != nil:
    section.add "subscriptionId", valid_597013
  var valid_597014 = path.getOrDefault("resourceName")
  valid_597014 = validateParameter(valid_597014, JString, required = true,
                                 default = nil)
  if valid_597014 != nil:
    section.add "resourceName", valid_597014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597015 = query.getOrDefault("api-version")
  valid_597015 = validateParameter(valid_597015, JString, required = true,
                                 default = nil)
  if valid_597015 != nil:
    section.add "api-version", valid_597015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597016: Call_WorkbooksGet_597009; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a single workbook by its resourceName.
  ## 
  let valid = call_597016.validator(path, query, header, formData, body)
  let scheme = call_597016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597016.url(scheme.get, call_597016.host, call_597016.base,
                         call_597016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597016, url, valid)

proc call*(call_597017: Call_WorkbooksGet_597009; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## workbooksGet
  ## Get a single workbook by its resourceName.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_597018 = newJObject()
  var query_597019 = newJObject()
  add(path_597018, "resourceGroupName", newJString(resourceGroupName))
  add(query_597019, "api-version", newJString(apiVersion))
  add(path_597018, "subscriptionId", newJString(subscriptionId))
  add(path_597018, "resourceName", newJString(resourceName))
  result = call_597017.call(path_597018, query_597019, nil, nil, nil)

var workbooksGet* = Call_WorkbooksGet_597009(name: "workbooksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/microsoft.insights/workbooks/{resourceName}",
    validator: validate_WorkbooksGet_597010, base: "", url: url_WorkbooksGet_597011,
    schemes: {Scheme.Https})
type
  Call_WorkbooksUpdate_597061 = ref object of OpenApiRestCall_596458
proc url_WorkbooksUpdate_597063(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/resourceGroup/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/workbooks/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkbooksUpdate_597062(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a workbook that has already been added.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597064 = path.getOrDefault("resourceGroupName")
  valid_597064 = validateParameter(valid_597064, JString, required = true,
                                 default = nil)
  if valid_597064 != nil:
    section.add "resourceGroupName", valid_597064
  var valid_597065 = path.getOrDefault("subscriptionId")
  valid_597065 = validateParameter(valid_597065, JString, required = true,
                                 default = nil)
  if valid_597065 != nil:
    section.add "subscriptionId", valid_597065
  var valid_597066 = path.getOrDefault("resourceName")
  valid_597066 = validateParameter(valid_597066, JString, required = true,
                                 default = nil)
  if valid_597066 != nil:
    section.add "resourceName", valid_597066
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597067 = query.getOrDefault("api-version")
  valid_597067 = validateParameter(valid_597067, JString, required = true,
                                 default = nil)
  if valid_597067 != nil:
    section.add "api-version", valid_597067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   workbookProperties: JObject (required)
  ##                     : Properties that need to be specified to create a new workbook.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597069: Call_WorkbooksUpdate_597061; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a workbook that has already been added.
  ## 
  let valid = call_597069.validator(path, query, header, formData, body)
  let scheme = call_597069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597069.url(scheme.get, call_597069.host, call_597069.base,
                         call_597069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597069, url, valid)

proc call*(call_597070: Call_WorkbooksUpdate_597061; resourceGroupName: string;
          workbookProperties: JsonNode; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## workbooksUpdate
  ## Updates a workbook that has already been added.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   workbookProperties: JObject (required)
  ##                     : Properties that need to be specified to create a new workbook.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_597071 = newJObject()
  var query_597072 = newJObject()
  var body_597073 = newJObject()
  add(path_597071, "resourceGroupName", newJString(resourceGroupName))
  if workbookProperties != nil:
    body_597073 = workbookProperties
  add(query_597072, "api-version", newJString(apiVersion))
  add(path_597071, "subscriptionId", newJString(subscriptionId))
  add(path_597071, "resourceName", newJString(resourceName))
  result = call_597070.call(path_597071, query_597072, nil, nil, body_597073)

var workbooksUpdate* = Call_WorkbooksUpdate_597061(name: "workbooksUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/microsoft.insights/workbooks/{resourceName}",
    validator: validate_WorkbooksUpdate_597062, base: "", url: url_WorkbooksUpdate_597063,
    schemes: {Scheme.Https})
type
  Call_WorkbooksDelete_597050 = ref object of OpenApiRestCall_596458
proc url_WorkbooksDelete_597052(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/resourceGroup/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/workbooks/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkbooksDelete_597051(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete a workbook.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597053 = path.getOrDefault("resourceGroupName")
  valid_597053 = validateParameter(valid_597053, JString, required = true,
                                 default = nil)
  if valid_597053 != nil:
    section.add "resourceGroupName", valid_597053
  var valid_597054 = path.getOrDefault("subscriptionId")
  valid_597054 = validateParameter(valid_597054, JString, required = true,
                                 default = nil)
  if valid_597054 != nil:
    section.add "subscriptionId", valid_597054
  var valid_597055 = path.getOrDefault("resourceName")
  valid_597055 = validateParameter(valid_597055, JString, required = true,
                                 default = nil)
  if valid_597055 != nil:
    section.add "resourceName", valid_597055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597056 = query.getOrDefault("api-version")
  valid_597056 = validateParameter(valid_597056, JString, required = true,
                                 default = nil)
  if valid_597056 != nil:
    section.add "api-version", valid_597056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597057: Call_WorkbooksDelete_597050; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a workbook.
  ## 
  let valid = call_597057.validator(path, query, header, formData, body)
  let scheme = call_597057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597057.url(scheme.get, call_597057.host, call_597057.base,
                         call_597057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597057, url, valid)

proc call*(call_597058: Call_WorkbooksDelete_597050; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## workbooksDelete
  ## Delete a workbook.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_597059 = newJObject()
  var query_597060 = newJObject()
  add(path_597059, "resourceGroupName", newJString(resourceGroupName))
  add(query_597060, "api-version", newJString(apiVersion))
  add(path_597059, "subscriptionId", newJString(subscriptionId))
  add(path_597059, "resourceName", newJString(resourceName))
  result = call_597058.call(path_597059, query_597060, nil, nil, nil)

var workbooksDelete* = Call_WorkbooksDelete_597050(name: "workbooksDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/microsoft.insights/workbooks/{resourceName}",
    validator: validate_WorkbooksDelete_597051, base: "", url: url_WorkbooksDelete_597052,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
