
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApplicationInsightsManagementClient
## version: 2015-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Application Insights client for Annotations for a component.
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
  macServiceName = "applicationinsights-componentAnnotations_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AnnotationsCreate_596996 = ref object of OpenApiRestCall_596458
proc url_AnnotationsCreate_596998(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/Annotations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnnotationsCreate_596997(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Create an Annotation of an Application Insights component.
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
  var valid_596999 = path.getOrDefault("resourceGroupName")
  valid_596999 = validateParameter(valid_596999, JString, required = true,
                                 default = nil)
  if valid_596999 != nil:
    section.add "resourceGroupName", valid_596999
  var valid_597000 = path.getOrDefault("subscriptionId")
  valid_597000 = validateParameter(valid_597000, JString, required = true,
                                 default = nil)
  if valid_597000 != nil:
    section.add "subscriptionId", valid_597000
  var valid_597001 = path.getOrDefault("resourceName")
  valid_597001 = validateParameter(valid_597001, JString, required = true,
                                 default = nil)
  if valid_597001 != nil:
    section.add "resourceName", valid_597001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597002 = query.getOrDefault("api-version")
  valid_597002 = validateParameter(valid_597002, JString, required = true,
                                 default = nil)
  if valid_597002 != nil:
    section.add "api-version", valid_597002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   AnnotationProperties: JObject (required)
  ##                       : Properties that need to be specified to create an annotation of a Application Insights component.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597004: Call_AnnotationsCreate_596996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an Annotation of an Application Insights component.
  ## 
  let valid = call_597004.validator(path, query, header, formData, body)
  let scheme = call_597004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597004.url(scheme.get, call_597004.host, call_597004.base,
                         call_597004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597004, url, valid)

proc call*(call_597005: Call_AnnotationsCreate_596996; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          AnnotationProperties: JsonNode): Recallable =
  ## annotationsCreate
  ## Create an Annotation of an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   AnnotationProperties: JObject (required)
  ##                       : Properties that need to be specified to create an annotation of a Application Insights component.
  var path_597006 = newJObject()
  var query_597007 = newJObject()
  var body_597008 = newJObject()
  add(path_597006, "resourceGroupName", newJString(resourceGroupName))
  add(query_597007, "api-version", newJString(apiVersion))
  add(path_597006, "subscriptionId", newJString(subscriptionId))
  add(path_597006, "resourceName", newJString(resourceName))
  if AnnotationProperties != nil:
    body_597008 = AnnotationProperties
  result = call_597005.call(path_597006, query_597007, nil, nil, body_597008)

var annotationsCreate* = Call_AnnotationsCreate_596996(name: "annotationsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/Annotations",
    validator: validate_AnnotationsCreate_596997, base: "",
    url: url_AnnotationsCreate_596998, schemes: {Scheme.Https})
type
  Call_AnnotationsList_596680 = ref object of OpenApiRestCall_596458
proc url_AnnotationsList_596682(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/Annotations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnnotationsList_596681(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the list of annotations for a component for given time range
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
  var valid_596857 = path.getOrDefault("resourceName")
  valid_596857 = validateParameter(valid_596857, JString, required = true,
                                 default = nil)
  if valid_596857 != nil:
    section.add "resourceName", valid_596857
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   end: JString (required)
  ##      : The end time to query for annotations.
  ##   start: JString (required)
  ##        : The start time to query from for annotations, cannot be older than 90 days from current date.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596858 = query.getOrDefault("api-version")
  valid_596858 = validateParameter(valid_596858, JString, required = true,
                                 default = nil)
  if valid_596858 != nil:
    section.add "api-version", valid_596858
  var valid_596859 = query.getOrDefault("end")
  valid_596859 = validateParameter(valid_596859, JString, required = true,
                                 default = nil)
  if valid_596859 != nil:
    section.add "end", valid_596859
  var valid_596860 = query.getOrDefault("start")
  valid_596860 = validateParameter(valid_596860, JString, required = true,
                                 default = nil)
  if valid_596860 != nil:
    section.add "start", valid_596860
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596883: Call_AnnotationsList_596680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of annotations for a component for given time range
  ## 
  let valid = call_596883.validator(path, query, header, formData, body)
  let scheme = call_596883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596883.url(scheme.get, call_596883.host, call_596883.base,
                         call_596883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596883, url, valid)

proc call*(call_596954: Call_AnnotationsList_596680; resourceGroupName: string;
          apiVersion: string; `end`: string; subscriptionId: string;
          resourceName: string; start: string): Recallable =
  ## annotationsList
  ## Gets the list of annotations for a component for given time range
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   end: string (required)
  ##      : The end time to query for annotations.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   start: string (required)
  ##        : The start time to query from for annotations, cannot be older than 90 days from current date.
  var path_596955 = newJObject()
  var query_596957 = newJObject()
  add(path_596955, "resourceGroupName", newJString(resourceGroupName))
  add(query_596957, "api-version", newJString(apiVersion))
  add(query_596957, "end", newJString(`end`))
  add(path_596955, "subscriptionId", newJString(subscriptionId))
  add(path_596955, "resourceName", newJString(resourceName))
  add(query_596957, "start", newJString(start))
  result = call_596954.call(path_596955, query_596957, nil, nil, nil)

var annotationsList* = Call_AnnotationsList_596680(name: "annotationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/Annotations",
    validator: validate_AnnotationsList_596681, base: "", url: url_AnnotationsList_596682,
    schemes: {Scheme.Https})
type
  Call_AnnotationsGet_597009 = ref object of OpenApiRestCall_596458
proc url_AnnotationsGet_597011(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "annotationId" in path, "`annotationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/Annotations/"),
               (kind: VariableSegment, value: "annotationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnnotationsGet_597010(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get the annotation for given id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   annotationId: JString (required)
  ##               : The unique annotation ID. This is unique within a Application Insights component.
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
  var valid_597014 = path.getOrDefault("annotationId")
  valid_597014 = validateParameter(valid_597014, JString, required = true,
                                 default = nil)
  if valid_597014 != nil:
    section.add "annotationId", valid_597014
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

proc call*(call_597017: Call_AnnotationsGet_597009; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the annotation for given id.
  ## 
  let valid = call_597017.validator(path, query, header, formData, body)
  let scheme = call_597017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597017.url(scheme.get, call_597017.host, call_597017.base,
                         call_597017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597017, url, valid)

proc call*(call_597018: Call_AnnotationsGet_597009; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; annotationId: string;
          resourceName: string): Recallable =
  ## annotationsGet
  ## Get the annotation for given id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   annotationId: string (required)
  ##               : The unique annotation ID. This is unique within a Application Insights component.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_597019 = newJObject()
  var query_597020 = newJObject()
  add(path_597019, "resourceGroupName", newJString(resourceGroupName))
  add(query_597020, "api-version", newJString(apiVersion))
  add(path_597019, "subscriptionId", newJString(subscriptionId))
  add(path_597019, "annotationId", newJString(annotationId))
  add(path_597019, "resourceName", newJString(resourceName))
  result = call_597018.call(path_597019, query_597020, nil, nil, nil)

var annotationsGet* = Call_AnnotationsGet_597009(name: "annotationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/Annotations/{annotationId}",
    validator: validate_AnnotationsGet_597010, base: "", url: url_AnnotationsGet_597011,
    schemes: {Scheme.Https})
type
  Call_AnnotationsDelete_597021 = ref object of OpenApiRestCall_596458
proc url_AnnotationsDelete_597023(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "annotationId" in path, "`annotationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/Annotations/"),
               (kind: VariableSegment, value: "annotationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnnotationsDelete_597022(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete an Annotation of an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   annotationId: JString (required)
  ##               : The unique annotation ID. This is unique within a Application Insights component.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597024 = path.getOrDefault("resourceGroupName")
  valid_597024 = validateParameter(valid_597024, JString, required = true,
                                 default = nil)
  if valid_597024 != nil:
    section.add "resourceGroupName", valid_597024
  var valid_597025 = path.getOrDefault("subscriptionId")
  valid_597025 = validateParameter(valid_597025, JString, required = true,
                                 default = nil)
  if valid_597025 != nil:
    section.add "subscriptionId", valid_597025
  var valid_597026 = path.getOrDefault("annotationId")
  valid_597026 = validateParameter(valid_597026, JString, required = true,
                                 default = nil)
  if valid_597026 != nil:
    section.add "annotationId", valid_597026
  var valid_597027 = path.getOrDefault("resourceName")
  valid_597027 = validateParameter(valid_597027, JString, required = true,
                                 default = nil)
  if valid_597027 != nil:
    section.add "resourceName", valid_597027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597028 = query.getOrDefault("api-version")
  valid_597028 = validateParameter(valid_597028, JString, required = true,
                                 default = nil)
  if valid_597028 != nil:
    section.add "api-version", valid_597028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597029: Call_AnnotationsDelete_597021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an Annotation of an Application Insights component.
  ## 
  let valid = call_597029.validator(path, query, header, formData, body)
  let scheme = call_597029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597029.url(scheme.get, call_597029.host, call_597029.base,
                         call_597029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597029, url, valid)

proc call*(call_597030: Call_AnnotationsDelete_597021; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; annotationId: string;
          resourceName: string): Recallable =
  ## annotationsDelete
  ## Delete an Annotation of an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   annotationId: string (required)
  ##               : The unique annotation ID. This is unique within a Application Insights component.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_597031 = newJObject()
  var query_597032 = newJObject()
  add(path_597031, "resourceGroupName", newJString(resourceGroupName))
  add(query_597032, "api-version", newJString(apiVersion))
  add(path_597031, "subscriptionId", newJString(subscriptionId))
  add(path_597031, "annotationId", newJString(annotationId))
  add(path_597031, "resourceName", newJString(resourceName))
  result = call_597030.call(path_597031, query_597032, nil, nil, nil)

var annotationsDelete* = Call_AnnotationsDelete_597021(name: "annotationsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/Annotations/{annotationId}",
    validator: validate_AnnotationsDelete_597022, base: "",
    url: url_AnnotationsDelete_597023, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
