
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApplicationInsightsManagementClient
## version: 2018-06-17-preview
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
  ##   sourceId: JString (required)
  ##           : Azure Resource Id that will fetch all related workbooks.
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
  var valid_596858 = query.getOrDefault("sourceId")
  valid_596858 = validateParameter(valid_596858, JString, required = true,
                                 default = nil)
  if valid_596858 != nil:
    section.add "sourceId", valid_596858
  var valid_596859 = query.getOrDefault("tags")
  valid_596859 = validateParameter(valid_596859, JArray, required = false,
                                 default = nil)
  if valid_596859 != nil:
    section.add "tags", valid_596859
  var valid_596873 = query.getOrDefault("category")
  valid_596873 = validateParameter(valid_596873, JString, required = true,
                                 default = newJString("workbook"))
  if valid_596873 != nil:
    section.add "category", valid_596873
  var valid_596874 = query.getOrDefault("canFetchContent")
  valid_596874 = validateParameter(valid_596874, JBool, required = false, default = nil)
  if valid_596874 != nil:
    section.add "canFetchContent", valid_596874
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596897: Call_WorkbooksListByResourceGroup_596680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Workbooks defined within a specified resource group and category.
  ## 
  let valid = call_596897.validator(path, query, header, formData, body)
  let scheme = call_596897.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596897.url(scheme.get, call_596897.host, call_596897.base,
                         call_596897.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596897, url, valid)

proc call*(call_596968: Call_WorkbooksListByResourceGroup_596680;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          sourceId: string; tags: JsonNode = nil; category: string = "workbook";
          canFetchContent: bool = false): Recallable =
  ## workbooksListByResourceGroup
  ## Get all Workbooks defined within a specified resource group and category.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   sourceId: string (required)
  ##           : Azure Resource Id that will fetch all related workbooks.
  ##   tags: JArray
  ##       : Tags presents on each workbook returned.
  ##   category: string (required)
  ##           : Category of workbook to return.
  ##   canFetchContent: bool
  ##                  : Flag indicating whether or not to return the full content for each applicable workbook. If false, only return summary content for workbooks.
  var path_596969 = newJObject()
  var query_596971 = newJObject()
  add(path_596969, "resourceGroupName", newJString(resourceGroupName))
  add(query_596971, "api-version", newJString(apiVersion))
  add(path_596969, "subscriptionId", newJString(subscriptionId))
  add(query_596971, "sourceId", newJString(sourceId))
  if tags != nil:
    query_596971.add "tags", tags
  add(query_596971, "category", newJString(category))
  add(query_596971, "canFetchContent", newJBool(canFetchContent))
  result = call_596968.call(path_596969, query_596971, nil, nil, nil)

var workbooksListByResourceGroup* = Call_WorkbooksListByResourceGroup_596680(
    name: "workbooksListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/microsoft.insights/workbooks",
    validator: validate_WorkbooksListByResourceGroup_596681, base: "",
    url: url_WorkbooksListByResourceGroup_596682, schemes: {Scheme.Https})
type
  Call_WorkbooksCreateOrUpdate_597021 = ref object of OpenApiRestCall_596458
proc url_WorkbooksCreateOrUpdate_597023(protocol: Scheme; host: string; base: string;
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

proc validate_WorkbooksCreateOrUpdate_597022(path: JsonNode; query: JsonNode;
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
  var valid_597041 = path.getOrDefault("resourceGroupName")
  valid_597041 = validateParameter(valid_597041, JString, required = true,
                                 default = nil)
  if valid_597041 != nil:
    section.add "resourceGroupName", valid_597041
  var valid_597042 = path.getOrDefault("subscriptionId")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "subscriptionId", valid_597042
  var valid_597043 = path.getOrDefault("resourceName")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "resourceName", valid_597043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   sourceId: JString (required)
  ##           : Azure Resource Id that will fetch all related workbooks.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597044 = query.getOrDefault("api-version")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "api-version", valid_597044
  var valid_597045 = query.getOrDefault("sourceId")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = nil)
  if valid_597045 != nil:
    section.add "sourceId", valid_597045
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

proc call*(call_597047: Call_WorkbooksCreateOrUpdate_597021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new workbook.
  ## 
  let valid = call_597047.validator(path, query, header, formData, body)
  let scheme = call_597047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597047.url(scheme.get, call_597047.host, call_597047.base,
                         call_597047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597047, url, valid)

proc call*(call_597048: Call_WorkbooksCreateOrUpdate_597021;
          resourceGroupName: string; workbookProperties: JsonNode;
          apiVersion: string; subscriptionId: string; resourceName: string;
          sourceId: string): Recallable =
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
  ##   sourceId: string (required)
  ##           : Azure Resource Id that will fetch all related workbooks.
  var path_597049 = newJObject()
  var query_597050 = newJObject()
  var body_597051 = newJObject()
  add(path_597049, "resourceGroupName", newJString(resourceGroupName))
  if workbookProperties != nil:
    body_597051 = workbookProperties
  add(query_597050, "api-version", newJString(apiVersion))
  add(path_597049, "subscriptionId", newJString(subscriptionId))
  add(path_597049, "resourceName", newJString(resourceName))
  add(query_597050, "sourceId", newJString(sourceId))
  result = call_597048.call(path_597049, query_597050, nil, nil, body_597051)

var workbooksCreateOrUpdate* = Call_WorkbooksCreateOrUpdate_597021(
    name: "workbooksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/microsoft.insights/workbooks/{resourceName}",
    validator: validate_WorkbooksCreateOrUpdate_597022, base: "",
    url: url_WorkbooksCreateOrUpdate_597023, schemes: {Scheme.Https})
type
  Call_WorkbooksGet_597010 = ref object of OpenApiRestCall_596458
proc url_WorkbooksGet_597012(protocol: Scheme; host: string; base: string;
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

proc validate_WorkbooksGet_597011(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_597013 = path.getOrDefault("resourceGroupName")
  valid_597013 = validateParameter(valid_597013, JString, required = true,
                                 default = nil)
  if valid_597013 != nil:
    section.add "resourceGroupName", valid_597013
  var valid_597014 = path.getOrDefault("subscriptionId")
  valid_597014 = validateParameter(valid_597014, JString, required = true,
                                 default = nil)
  if valid_597014 != nil:
    section.add "subscriptionId", valid_597014
  var valid_597015 = path.getOrDefault("resourceName")
  valid_597015 = validateParameter(valid_597015, JString, required = true,
                                 default = nil)
  if valid_597015 != nil:
    section.add "resourceName", valid_597015
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597016 = query.getOrDefault("api-version")
  valid_597016 = validateParameter(valid_597016, JString, required = true,
                                 default = nil)
  if valid_597016 != nil:
    section.add "api-version", valid_597016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597017: Call_WorkbooksGet_597010; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a single workbook by its resourceName.
  ## 
  let valid = call_597017.validator(path, query, header, formData, body)
  let scheme = call_597017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597017.url(scheme.get, call_597017.host, call_597017.base,
                         call_597017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597017, url, valid)

proc call*(call_597018: Call_WorkbooksGet_597010; resourceGroupName: string;
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
  var path_597019 = newJObject()
  var query_597020 = newJObject()
  add(path_597019, "resourceGroupName", newJString(resourceGroupName))
  add(query_597020, "api-version", newJString(apiVersion))
  add(path_597019, "subscriptionId", newJString(subscriptionId))
  add(path_597019, "resourceName", newJString(resourceName))
  result = call_597018.call(path_597019, query_597020, nil, nil, nil)

var workbooksGet* = Call_WorkbooksGet_597010(name: "workbooksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/microsoft.insights/workbooks/{resourceName}",
    validator: validate_WorkbooksGet_597011, base: "", url: url_WorkbooksGet_597012,
    schemes: {Scheme.Https})
type
  Call_WorkbooksUpdate_597063 = ref object of OpenApiRestCall_596458
proc url_WorkbooksUpdate_597065(protocol: Scheme; host: string; base: string;
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

proc validate_WorkbooksUpdate_597064(path: JsonNode; query: JsonNode;
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
  var valid_597066 = path.getOrDefault("resourceGroupName")
  valid_597066 = validateParameter(valid_597066, JString, required = true,
                                 default = nil)
  if valid_597066 != nil:
    section.add "resourceGroupName", valid_597066
  var valid_597067 = path.getOrDefault("subscriptionId")
  valid_597067 = validateParameter(valid_597067, JString, required = true,
                                 default = nil)
  if valid_597067 != nil:
    section.add "subscriptionId", valid_597067
  var valid_597068 = path.getOrDefault("resourceName")
  valid_597068 = validateParameter(valid_597068, JString, required = true,
                                 default = nil)
  if valid_597068 != nil:
    section.add "resourceName", valid_597068
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   sourceId: JString (required)
  ##           : Azure Resource Id that will fetch all related workbooks.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597069 = query.getOrDefault("api-version")
  valid_597069 = validateParameter(valid_597069, JString, required = true,
                                 default = nil)
  if valid_597069 != nil:
    section.add "api-version", valid_597069
  var valid_597070 = query.getOrDefault("sourceId")
  valid_597070 = validateParameter(valid_597070, JString, required = true,
                                 default = nil)
  if valid_597070 != nil:
    section.add "sourceId", valid_597070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   WorkbookUpdateParameters: JObject
  ##                           : Properties that need to be specified to create a new workbook.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597072: Call_WorkbooksUpdate_597063; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a workbook that has already been added.
  ## 
  let valid = call_597072.validator(path, query, header, formData, body)
  let scheme = call_597072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597072.url(scheme.get, call_597072.host, call_597072.base,
                         call_597072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597072, url, valid)

proc call*(call_597073: Call_WorkbooksUpdate_597063; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          sourceId: string; WorkbookUpdateParameters: JsonNode = nil): Recallable =
  ## workbooksUpdate
  ## Updates a workbook that has already been added.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   WorkbookUpdateParameters: JObject
  ##                           : Properties that need to be specified to create a new workbook.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   sourceId: string (required)
  ##           : Azure Resource Id that will fetch all related workbooks.
  var path_597074 = newJObject()
  var query_597075 = newJObject()
  var body_597076 = newJObject()
  add(path_597074, "resourceGroupName", newJString(resourceGroupName))
  add(query_597075, "api-version", newJString(apiVersion))
  add(path_597074, "subscriptionId", newJString(subscriptionId))
  if WorkbookUpdateParameters != nil:
    body_597076 = WorkbookUpdateParameters
  add(path_597074, "resourceName", newJString(resourceName))
  add(query_597075, "sourceId", newJString(sourceId))
  result = call_597073.call(path_597074, query_597075, nil, nil, body_597076)

var workbooksUpdate* = Call_WorkbooksUpdate_597063(name: "workbooksUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/microsoft.insights/workbooks/{resourceName}",
    validator: validate_WorkbooksUpdate_597064, base: "", url: url_WorkbooksUpdate_597065,
    schemes: {Scheme.Https})
type
  Call_WorkbooksDelete_597052 = ref object of OpenApiRestCall_596458
proc url_WorkbooksDelete_597054(protocol: Scheme; host: string; base: string;
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

proc validate_WorkbooksDelete_597053(path: JsonNode; query: JsonNode;
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
  var valid_597055 = path.getOrDefault("resourceGroupName")
  valid_597055 = validateParameter(valid_597055, JString, required = true,
                                 default = nil)
  if valid_597055 != nil:
    section.add "resourceGroupName", valid_597055
  var valid_597056 = path.getOrDefault("subscriptionId")
  valid_597056 = validateParameter(valid_597056, JString, required = true,
                                 default = nil)
  if valid_597056 != nil:
    section.add "subscriptionId", valid_597056
  var valid_597057 = path.getOrDefault("resourceName")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "resourceName", valid_597057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597058 = query.getOrDefault("api-version")
  valid_597058 = validateParameter(valid_597058, JString, required = true,
                                 default = nil)
  if valid_597058 != nil:
    section.add "api-version", valid_597058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597059: Call_WorkbooksDelete_597052; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a workbook.
  ## 
  let valid = call_597059.validator(path, query, header, formData, body)
  let scheme = call_597059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597059.url(scheme.get, call_597059.host, call_597059.base,
                         call_597059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597059, url, valid)

proc call*(call_597060: Call_WorkbooksDelete_597052; resourceGroupName: string;
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
  var path_597061 = newJObject()
  var query_597062 = newJObject()
  add(path_597061, "resourceGroupName", newJString(resourceGroupName))
  add(query_597062, "api-version", newJString(apiVersion))
  add(path_597061, "subscriptionId", newJString(subscriptionId))
  add(path_597061, "resourceName", newJString(resourceName))
  result = call_597060.call(path_597061, query_597062, nil, nil, nil)

var workbooksDelete* = Call_WorkbooksDelete_597052(name: "workbooksDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/microsoft.insights/workbooks/{resourceName}",
    validator: validate_WorkbooksDelete_597053, base: "", url: url_WorkbooksDelete_597054,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
