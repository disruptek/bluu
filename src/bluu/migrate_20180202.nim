
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Migrate
## version: 2018-02-02
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
  Call_AssessmentOptionsGet_564008 = ref object of OpenApiRestCall_563557
proc url_AssessmentOptionsGet_564010(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/assessmentOptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentOptionsGet_564009(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the available options for the properties of an assessment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : Azure region in which the project is created.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564090 = path.getOrDefault("locationName")
  valid_564090 = validateParameter(valid_564090, JString, required = true,
                                 default = nil)
  if valid_564090 != nil:
    section.add "locationName", valid_564090
  var valid_564091 = path.getOrDefault("subscriptionId")
  valid_564091 = validateParameter(valid_564091, JString, required = true,
                                 default = nil)
  if valid_564091 != nil:
    section.add "subscriptionId", valid_564091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564105 = query.getOrDefault("api-version")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564105 != nil:
    section.add "api-version", valid_564105
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564106 = header.getOrDefault("Accept-Language")
  valid_564106 = validateParameter(valid_564106, JString, required = false,
                                 default = nil)
  if valid_564106 != nil:
    section.add "Accept-Language", valid_564106
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564107: Call_AssessmentOptionsGet_564008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the available options for the properties of an assessment.
  ## 
  let valid = call_564107.validator(path, query, header, formData, body)
  let scheme = call_564107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564107.url(scheme.get, call_564107.host, call_564107.base,
                         call_564107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564107, url, valid)

proc call*(call_564108: Call_AssessmentOptionsGet_564008; locationName: string;
          subscriptionId: string; apiVersion: string = "2018-02-02"): Recallable =
  ## assessmentOptionsGet
  ## Get the available options for the properties of an assessment.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   locationName: string (required)
  ##               : Azure region in which the project is created.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  var path_564109 = newJObject()
  var query_564111 = newJObject()
  add(query_564111, "api-version", newJString(apiVersion))
  add(path_564109, "locationName", newJString(locationName))
  add(path_564109, "subscriptionId", newJString(subscriptionId))
  result = call_564108.call(path_564109, query_564111, nil, nil, nil)

var assessmentOptionsGet* = Call_AssessmentOptionsGet_564008(
    name: "assessmentOptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Migrate/locations/{locationName}/assessmentOptions",
    validator: validate_AssessmentOptionsGet_564009, base: "",
    url: url_AssessmentOptionsGet_564010, schemes: {Scheme.Https})
type
  Call_LocationCheckNameAvailability_564113 = ref object of OpenApiRestCall_563557
proc url_LocationCheckNameAvailability_564115(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationCheckNameAvailability_564114(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the project name is available in the specified region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The desired region for the name check.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564133 = path.getOrDefault("locationName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "locationName", valid_564133
  var valid_564134 = path.getOrDefault("subscriptionId")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "subscriptionId", valid_564134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564135 = query.getOrDefault("api-version")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564135 != nil:
    section.add "api-version", valid_564135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Properties needed to check the availability of a name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564137: Call_LocationCheckNameAvailability_564113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the project name is available in the specified region.
  ## 
  let valid = call_564137.validator(path, query, header, formData, body)
  let scheme = call_564137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564137.url(scheme.get, call_564137.host, call_564137.base,
                         call_564137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564137, url, valid)

proc call*(call_564138: Call_LocationCheckNameAvailability_564113;
          locationName: string; subscriptionId: string; parameters: JsonNode;
          apiVersion: string = "2018-02-02"): Recallable =
  ## locationCheckNameAvailability
  ## Checks whether the project name is available in the specified region.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   locationName: string (required)
  ##               : The desired region for the name check.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   parameters: JObject (required)
  ##             : Properties needed to check the availability of a name.
  var path_564139 = newJObject()
  var query_564140 = newJObject()
  var body_564141 = newJObject()
  add(query_564140, "api-version", newJString(apiVersion))
  add(path_564139, "locationName", newJString(locationName))
  add(path_564139, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564141 = parameters
  result = call_564138.call(path_564139, query_564140, nil, nil, body_564141)

var locationCheckNameAvailability* = Call_LocationCheckNameAvailability_564113(
    name: "locationCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Migrate/locations/{locationName}/checkNameAvailability",
    validator: validate_LocationCheckNameAvailability_564114, base: "",
    url: url_LocationCheckNameAvailability_564115, schemes: {Scheme.Https})
type
  Call_ProjectsListBySubscription_564142 = ref object of OpenApiRestCall_563557
proc url_ProjectsListBySubscription_564144(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsListBySubscription_564143(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the projects in the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564145 = path.getOrDefault("subscriptionId")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "subscriptionId", valid_564145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564146 = query.getOrDefault("api-version")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = newJString("2018-02-02"))
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
  if body != nil:
    result.add "body", body

proc call*(call_564148: Call_ProjectsListBySubscription_564142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the projects in the subscription.
  ## 
  let valid = call_564148.validator(path, query, header, formData, body)
  let scheme = call_564148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564148.url(scheme.get, call_564148.host, call_564148.base,
                         call_564148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564148, url, valid)

proc call*(call_564149: Call_ProjectsListBySubscription_564142;
          subscriptionId: string; apiVersion: string = "2018-02-02"): Recallable =
  ## projectsListBySubscription
  ## Get all the projects in the subscription.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  var path_564150 = newJObject()
  var query_564151 = newJObject()
  add(query_564151, "api-version", newJString(apiVersion))
  add(path_564150, "subscriptionId", newJString(subscriptionId))
  result = call_564149.call(path_564150, query_564151, nil, nil, nil)

var projectsListBySubscription* = Call_ProjectsListBySubscription_564142(
    name: "projectsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Migrate/projects",
    validator: validate_ProjectsListBySubscription_564143, base: "",
    url: url_ProjectsListBySubscription_564144, schemes: {Scheme.Https})
type
  Call_AssessmentsListByProject_564152 = ref object of OpenApiRestCall_563557
proc url_AssessmentsListByProject_564154(protocol: Scheme; host: string;
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

proc validate_AssessmentsListByProject_564153(path: JsonNode; query: JsonNode;
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
  var valid_564155 = path.getOrDefault("subscriptionId")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "subscriptionId", valid_564155
  var valid_564156 = path.getOrDefault("resourceGroupName")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "resourceGroupName", valid_564156
  var valid_564157 = path.getOrDefault("projectName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "projectName", valid_564157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564158 = query.getOrDefault("api-version")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564158 != nil:
    section.add "api-version", valid_564158
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564159 = header.getOrDefault("Accept-Language")
  valid_564159 = validateParameter(valid_564159, JString, required = false,
                                 default = nil)
  if valid_564159 != nil:
    section.add "Accept-Language", valid_564159
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564160: Call_AssessmentsListByProject_564152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all assessments created in the project.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  let valid = call_564160.validator(path, query, header, formData, body)
  let scheme = call_564160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564160.url(scheme.get, call_564160.host, call_564160.base,
                         call_564160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564160, url, valid)

proc call*(call_564161: Call_AssessmentsListByProject_564152;
          subscriptionId: string; resourceGroupName: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
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
  var path_564162 = newJObject()
  var query_564163 = newJObject()
  add(query_564163, "api-version", newJString(apiVersion))
  add(path_564162, "subscriptionId", newJString(subscriptionId))
  add(path_564162, "resourceGroupName", newJString(resourceGroupName))
  add(path_564162, "projectName", newJString(projectName))
  result = call_564161.call(path_564162, query_564163, nil, nil, nil)

var assessmentsListByProject* = Call_AssessmentsListByProject_564152(
    name: "assessmentsListByProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/assessments",
    validator: validate_AssessmentsListByProject_564153, base: "",
    url: url_AssessmentsListByProject_564154, schemes: {Scheme.Https})
type
  Call_GroupsListByProject_564164 = ref object of OpenApiRestCall_563557
proc url_GroupsListByProject_564166(protocol: Scheme; host: string; base: string;
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

proc validate_GroupsListByProject_564165(path: JsonNode; query: JsonNode;
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
  var valid_564167 = path.getOrDefault("subscriptionId")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "subscriptionId", valid_564167
  var valid_564168 = path.getOrDefault("resourceGroupName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "resourceGroupName", valid_564168
  var valid_564169 = path.getOrDefault("projectName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "projectName", valid_564169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564170 = query.getOrDefault("api-version")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564170 != nil:
    section.add "api-version", valid_564170
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564171 = header.getOrDefault("Accept-Language")
  valid_564171 = validateParameter(valid_564171, JString, required = false,
                                 default = nil)
  if valid_564171 != nil:
    section.add "Accept-Language", valid_564171
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564172: Call_GroupsListByProject_564164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all groups created in the project. Returns a json array of objects of type 'group' as specified in the Models section.
  ## 
  let valid = call_564172.validator(path, query, header, formData, body)
  let scheme = call_564172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564172.url(scheme.get, call_564172.host, call_564172.base,
                         call_564172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564172, url, valid)

proc call*(call_564173: Call_GroupsListByProject_564164; subscriptionId: string;
          resourceGroupName: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
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
  var path_564174 = newJObject()
  var query_564175 = newJObject()
  add(query_564175, "api-version", newJString(apiVersion))
  add(path_564174, "subscriptionId", newJString(subscriptionId))
  add(path_564174, "resourceGroupName", newJString(resourceGroupName))
  add(path_564174, "projectName", newJString(projectName))
  result = call_564173.call(path_564174, query_564175, nil, nil, nil)

var groupsListByProject* = Call_GroupsListByProject_564164(
    name: "groupsListByProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups",
    validator: validate_GroupsListByProject_564165, base: "",
    url: url_GroupsListByProject_564166, schemes: {Scheme.Https})
type
  Call_GroupsCreate_564189 = ref object of OpenApiRestCall_563557
proc url_GroupsCreate_564191(protocol: Scheme; host: string; base: string;
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

proc validate_GroupsCreate_564190(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564192 = path.getOrDefault("subscriptionId")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "subscriptionId", valid_564192
  var valid_564193 = path.getOrDefault("resourceGroupName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "resourceGroupName", valid_564193
  var valid_564194 = path.getOrDefault("projectName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "projectName", valid_564194
  var valid_564195 = path.getOrDefault("groupName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "groupName", valid_564195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564196 = query.getOrDefault("api-version")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564196 != nil:
    section.add "api-version", valid_564196
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564197 = header.getOrDefault("Accept-Language")
  valid_564197 = validateParameter(valid_564197, JString, required = false,
                                 default = nil)
  if valid_564197 != nil:
    section.add "Accept-Language", valid_564197
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   group: JObject
  ##        : New or Updated Group object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564199: Call_GroupsCreate_564189; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new group by sending a json object of type 'group' as given in Models section as part of the Request Body. The group name in a project is unique. Labels can be applied on a group as part of creation.
  ## 
  ## If a group with the groupName specified in the URL already exists, then this call acts as an update.
  ## 
  ## This operation is Idempotent.
  ## 
  ## 
  let valid = call_564199.validator(path, query, header, formData, body)
  let scheme = call_564199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564199.url(scheme.get, call_564199.host, call_564199.base,
                         call_564199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564199, url, valid)

proc call*(call_564200: Call_GroupsCreate_564189; subscriptionId: string;
          resourceGroupName: string; projectName: string; groupName: string;
          apiVersion: string = "2018-02-02"; group: JsonNode = nil): Recallable =
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
  var path_564201 = newJObject()
  var query_564202 = newJObject()
  var body_564203 = newJObject()
  add(query_564202, "api-version", newJString(apiVersion))
  if group != nil:
    body_564203 = group
  add(path_564201, "subscriptionId", newJString(subscriptionId))
  add(path_564201, "resourceGroupName", newJString(resourceGroupName))
  add(path_564201, "projectName", newJString(projectName))
  add(path_564201, "groupName", newJString(groupName))
  result = call_564200.call(path_564201, query_564202, nil, nil, body_564203)

var groupsCreate* = Call_GroupsCreate_564189(name: "groupsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}",
    validator: validate_GroupsCreate_564190, base: "", url: url_GroupsCreate_564191,
    schemes: {Scheme.Https})
type
  Call_GroupsGet_564176 = ref object of OpenApiRestCall_563557
proc url_GroupsGet_564178(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GroupsGet_564177(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564179 = path.getOrDefault("subscriptionId")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "subscriptionId", valid_564179
  var valid_564180 = path.getOrDefault("resourceGroupName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "resourceGroupName", valid_564180
  var valid_564181 = path.getOrDefault("projectName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "projectName", valid_564181
  var valid_564182 = path.getOrDefault("groupName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "groupName", valid_564182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564183 = query.getOrDefault("api-version")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564183 != nil:
    section.add "api-version", valid_564183
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564184 = header.getOrDefault("Accept-Language")
  valid_564184 = validateParameter(valid_564184, JString, required = false,
                                 default = nil)
  if valid_564184 != nil:
    section.add "Accept-Language", valid_564184
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564185: Call_GroupsGet_564176; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific group in the project. Returns a json object of type 'group' as specified in the models section.
  ## 
  let valid = call_564185.validator(path, query, header, formData, body)
  let scheme = call_564185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564185.url(scheme.get, call_564185.host, call_564185.base,
                         call_564185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564185, url, valid)

proc call*(call_564186: Call_GroupsGet_564176; subscriptionId: string;
          resourceGroupName: string; projectName: string; groupName: string;
          apiVersion: string = "2018-02-02"): Recallable =
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
  var path_564187 = newJObject()
  var query_564188 = newJObject()
  add(query_564188, "api-version", newJString(apiVersion))
  add(path_564187, "subscriptionId", newJString(subscriptionId))
  add(path_564187, "resourceGroupName", newJString(resourceGroupName))
  add(path_564187, "projectName", newJString(projectName))
  add(path_564187, "groupName", newJString(groupName))
  result = call_564186.call(path_564187, query_564188, nil, nil, nil)

var groupsGet* = Call_GroupsGet_564176(name: "groupsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}",
                                    validator: validate_GroupsGet_564177,
                                    base: "", url: url_GroupsGet_564178,
                                    schemes: {Scheme.Https})
type
  Call_GroupsDelete_564204 = ref object of OpenApiRestCall_563557
proc url_GroupsDelete_564206(protocol: Scheme; host: string; base: string;
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

proc validate_GroupsDelete_564205(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564207 = path.getOrDefault("subscriptionId")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "subscriptionId", valid_564207
  var valid_564208 = path.getOrDefault("resourceGroupName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "resourceGroupName", valid_564208
  var valid_564209 = path.getOrDefault("projectName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "projectName", valid_564209
  var valid_564210 = path.getOrDefault("groupName")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "groupName", valid_564210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564211 = query.getOrDefault("api-version")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564211 != nil:
    section.add "api-version", valid_564211
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564212 = header.getOrDefault("Accept-Language")
  valid_564212 = validateParameter(valid_564212, JString, required = false,
                                 default = nil)
  if valid_564212 != nil:
    section.add "Accept-Language", valid_564212
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564213: Call_GroupsDelete_564204; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the group from the project. The machines remain in the project. Deleting a non-existent group results in a no-operation.
  ## 
  ## A group is an aggregation mechanism for machines in a project. Therefore, deleting group does not delete machines in it.
  ## 
  ## 
  let valid = call_564213.validator(path, query, header, formData, body)
  let scheme = call_564213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564213.url(scheme.get, call_564213.host, call_564213.base,
                         call_564213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564213, url, valid)

proc call*(call_564214: Call_GroupsDelete_564204; subscriptionId: string;
          resourceGroupName: string; projectName: string; groupName: string;
          apiVersion: string = "2018-02-02"): Recallable =
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
  var path_564215 = newJObject()
  var query_564216 = newJObject()
  add(query_564216, "api-version", newJString(apiVersion))
  add(path_564215, "subscriptionId", newJString(subscriptionId))
  add(path_564215, "resourceGroupName", newJString(resourceGroupName))
  add(path_564215, "projectName", newJString(projectName))
  add(path_564215, "groupName", newJString(groupName))
  result = call_564214.call(path_564215, query_564216, nil, nil, nil)

var groupsDelete* = Call_GroupsDelete_564204(name: "groupsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}",
    validator: validate_GroupsDelete_564205, base: "", url: url_GroupsDelete_564206,
    schemes: {Scheme.Https})
type
  Call_AssessmentsListByGroup_564217 = ref object of OpenApiRestCall_563557
proc url_AssessmentsListByGroup_564219(protocol: Scheme; host: string; base: string;
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

proc validate_AssessmentsListByGroup_564218(path: JsonNode; query: JsonNode;
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
  var valid_564220 = path.getOrDefault("subscriptionId")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "subscriptionId", valid_564220
  var valid_564221 = path.getOrDefault("resourceGroupName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "resourceGroupName", valid_564221
  var valid_564222 = path.getOrDefault("projectName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "projectName", valid_564222
  var valid_564223 = path.getOrDefault("groupName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "groupName", valid_564223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564224 = query.getOrDefault("api-version")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564224 != nil:
    section.add "api-version", valid_564224
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564225 = header.getOrDefault("Accept-Language")
  valid_564225 = validateParameter(valid_564225, JString, required = false,
                                 default = nil)
  if valid_564225 != nil:
    section.add "Accept-Language", valid_564225
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564226: Call_AssessmentsListByGroup_564217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all assessments created for the specified group.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  let valid = call_564226.validator(path, query, header, formData, body)
  let scheme = call_564226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564226.url(scheme.get, call_564226.host, call_564226.base,
                         call_564226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564226, url, valid)

proc call*(call_564227: Call_AssessmentsListByGroup_564217; subscriptionId: string;
          resourceGroupName: string; projectName: string; groupName: string;
          apiVersion: string = "2018-02-02"): Recallable =
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
  var path_564228 = newJObject()
  var query_564229 = newJObject()
  add(query_564229, "api-version", newJString(apiVersion))
  add(path_564228, "subscriptionId", newJString(subscriptionId))
  add(path_564228, "resourceGroupName", newJString(resourceGroupName))
  add(path_564228, "projectName", newJString(projectName))
  add(path_564228, "groupName", newJString(groupName))
  result = call_564227.call(path_564228, query_564229, nil, nil, nil)

var assessmentsListByGroup* = Call_AssessmentsListByGroup_564217(
    name: "assessmentsListByGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments",
    validator: validate_AssessmentsListByGroup_564218, base: "",
    url: url_AssessmentsListByGroup_564219, schemes: {Scheme.Https})
type
  Call_AssessmentsCreate_564244 = ref object of OpenApiRestCall_563557
proc url_AssessmentsCreate_564246(protocol: Scheme; host: string; base: string;
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

proc validate_AssessmentsCreate_564245(path: JsonNode; query: JsonNode;
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
  var valid_564247 = path.getOrDefault("assessmentName")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "assessmentName", valid_564247
  var valid_564248 = path.getOrDefault("subscriptionId")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "subscriptionId", valid_564248
  var valid_564249 = path.getOrDefault("resourceGroupName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "resourceGroupName", valid_564249
  var valid_564250 = path.getOrDefault("projectName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "projectName", valid_564250
  var valid_564251 = path.getOrDefault("groupName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "groupName", valid_564251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564252 = query.getOrDefault("api-version")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564252 != nil:
    section.add "api-version", valid_564252
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564253 = header.getOrDefault("Accept-Language")
  valid_564253 = validateParameter(valid_564253, JString, required = false,
                                 default = nil)
  if valid_564253 != nil:
    section.add "Accept-Language", valid_564253
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   assessment: JObject
  ##             : New or Updated Assessment object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564255: Call_AssessmentsCreate_564244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new assessment with the given name and the specified settings. Since name of an assessment in a project is a unique identifier, if an assessment with the name provided already exists, then the existing assessment is updated.
  ## 
  ## Any PUT operation, resulting in either create or update on an assessment, will cause the assessment to go in a "InProgress" state. This will be indicated by the field 'computationState' on the Assessment object. During this time no other PUT operation will be allowed on that assessment object, nor will a Delete operation. Once the computation for the assessment is complete, the field 'computationState' will be updated to 'Ready', and then other PUT or DELETE operations can happen on the assessment.
  ## 
  ## When assessment is under computation, any PUT will lead to a 400 - Bad Request error.
  ## 
  ## 
  let valid = call_564255.validator(path, query, header, formData, body)
  let scheme = call_564255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564255.url(scheme.get, call_564255.host, call_564255.base,
                         call_564255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564255, url, valid)

proc call*(call_564256: Call_AssessmentsCreate_564244; assessmentName: string;
          subscriptionId: string; resourceGroupName: string; projectName: string;
          groupName: string; apiVersion: string = "2018-02-02";
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
  var path_564257 = newJObject()
  var query_564258 = newJObject()
  var body_564259 = newJObject()
  add(path_564257, "assessmentName", newJString(assessmentName))
  add(query_564258, "api-version", newJString(apiVersion))
  if assessment != nil:
    body_564259 = assessment
  add(path_564257, "subscriptionId", newJString(subscriptionId))
  add(path_564257, "resourceGroupName", newJString(resourceGroupName))
  add(path_564257, "projectName", newJString(projectName))
  add(path_564257, "groupName", newJString(groupName))
  result = call_564256.call(path_564257, query_564258, nil, nil, body_564259)

var assessmentsCreate* = Call_AssessmentsCreate_564244(name: "assessmentsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}",
    validator: validate_AssessmentsCreate_564245, base: "",
    url: url_AssessmentsCreate_564246, schemes: {Scheme.Https})
type
  Call_AssessmentsGet_564230 = ref object of OpenApiRestCall_563557
proc url_AssessmentsGet_564232(protocol: Scheme; host: string; base: string;
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

proc validate_AssessmentsGet_564231(path: JsonNode; query: JsonNode;
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
  var valid_564233 = path.getOrDefault("assessmentName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "assessmentName", valid_564233
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
  var valid_564236 = path.getOrDefault("projectName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "projectName", valid_564236
  var valid_564237 = path.getOrDefault("groupName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "groupName", valid_564237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564238 = query.getOrDefault("api-version")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564238 != nil:
    section.add "api-version", valid_564238
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564239 = header.getOrDefault("Accept-Language")
  valid_564239 = validateParameter(valid_564239, JString, required = false,
                                 default = nil)
  if valid_564239 != nil:
    section.add "Accept-Language", valid_564239
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564240: Call_AssessmentsGet_564230; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an existing assessment with the specified name. Returns a json object of type 'assessment' as specified in Models section.
  ## 
  let valid = call_564240.validator(path, query, header, formData, body)
  let scheme = call_564240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564240.url(scheme.get, call_564240.host, call_564240.base,
                         call_564240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564240, url, valid)

proc call*(call_564241: Call_AssessmentsGet_564230; assessmentName: string;
          subscriptionId: string; resourceGroupName: string; projectName: string;
          groupName: string; apiVersion: string = "2018-02-02"): Recallable =
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
  var path_564242 = newJObject()
  var query_564243 = newJObject()
  add(path_564242, "assessmentName", newJString(assessmentName))
  add(query_564243, "api-version", newJString(apiVersion))
  add(path_564242, "subscriptionId", newJString(subscriptionId))
  add(path_564242, "resourceGroupName", newJString(resourceGroupName))
  add(path_564242, "projectName", newJString(projectName))
  add(path_564242, "groupName", newJString(groupName))
  result = call_564241.call(path_564242, query_564243, nil, nil, nil)

var assessmentsGet* = Call_AssessmentsGet_564230(name: "assessmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}",
    validator: validate_AssessmentsGet_564231, base: "", url: url_AssessmentsGet_564232,
    schemes: {Scheme.Https})
type
  Call_AssessmentsDelete_564260 = ref object of OpenApiRestCall_563557
proc url_AssessmentsDelete_564262(protocol: Scheme; host: string; base: string;
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

proc validate_AssessmentsDelete_564261(path: JsonNode; query: JsonNode;
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
  var valid_564263 = path.getOrDefault("assessmentName")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "assessmentName", valid_564263
  var valid_564264 = path.getOrDefault("subscriptionId")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "subscriptionId", valid_564264
  var valid_564265 = path.getOrDefault("resourceGroupName")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "resourceGroupName", valid_564265
  var valid_564266 = path.getOrDefault("projectName")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "projectName", valid_564266
  var valid_564267 = path.getOrDefault("groupName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "groupName", valid_564267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564268 = query.getOrDefault("api-version")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564268 != nil:
    section.add "api-version", valid_564268
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564269 = header.getOrDefault("Accept-Language")
  valid_564269 = validateParameter(valid_564269, JString, required = false,
                                 default = nil)
  if valid_564269 != nil:
    section.add "Accept-Language", valid_564269
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564270: Call_AssessmentsDelete_564260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an assessment from the project. The machines remain in the assessment. Deleting a non-existent assessment results in a no-operation.
  ## 
  ## When an assessment is under computation, as indicated by the 'computationState' field, it cannot be deleted. Any such attempt will return a 400 - Bad Request.
  ## 
  ## 
  let valid = call_564270.validator(path, query, header, formData, body)
  let scheme = call_564270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564270.url(scheme.get, call_564270.host, call_564270.base,
                         call_564270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564270, url, valid)

proc call*(call_564271: Call_AssessmentsDelete_564260; assessmentName: string;
          subscriptionId: string; resourceGroupName: string; projectName: string;
          groupName: string; apiVersion: string = "2018-02-02"): Recallable =
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
  var path_564272 = newJObject()
  var query_564273 = newJObject()
  add(path_564272, "assessmentName", newJString(assessmentName))
  add(query_564273, "api-version", newJString(apiVersion))
  add(path_564272, "subscriptionId", newJString(subscriptionId))
  add(path_564272, "resourceGroupName", newJString(resourceGroupName))
  add(path_564272, "projectName", newJString(projectName))
  add(path_564272, "groupName", newJString(groupName))
  result = call_564271.call(path_564272, query_564273, nil, nil, nil)

var assessmentsDelete* = Call_AssessmentsDelete_564260(name: "assessmentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}",
    validator: validate_AssessmentsDelete_564261, base: "",
    url: url_AssessmentsDelete_564262, schemes: {Scheme.Https})
type
  Call_AssessedMachinesListByAssessment_564274 = ref object of OpenApiRestCall_563557
proc url_AssessedMachinesListByAssessment_564276(protocol: Scheme; host: string;
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

proc validate_AssessedMachinesListByAssessment_564275(path: JsonNode;
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
  var valid_564277 = path.getOrDefault("assessmentName")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "assessmentName", valid_564277
  var valid_564278 = path.getOrDefault("subscriptionId")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "subscriptionId", valid_564278
  var valid_564279 = path.getOrDefault("resourceGroupName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "resourceGroupName", valid_564279
  var valid_564280 = path.getOrDefault("projectName")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "projectName", valid_564280
  var valid_564281 = path.getOrDefault("groupName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "groupName", valid_564281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564282 = query.getOrDefault("api-version")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564282 != nil:
    section.add "api-version", valid_564282
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564283 = header.getOrDefault("Accept-Language")
  valid_564283 = validateParameter(valid_564283, JString, required = false,
                                 default = nil)
  if valid_564283 != nil:
    section.add "Accept-Language", valid_564283
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564284: Call_AssessedMachinesListByAssessment_564274;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get list of machines that assessed as part of the specified assessment. Returns a json array of objects of type 'assessedMachine' as specified in the Models section.
  ## 
  ## Whenever an assessment is created or updated, it goes under computation. During this phase, the 'status' field of Assessment object reports 'Computing'.
  ## During the period when the assessment is under computation, the list of assessed machines is empty and no assessed machines are returned by this call.
  ## 
  ## 
  let valid = call_564284.validator(path, query, header, formData, body)
  let scheme = call_564284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564284.url(scheme.get, call_564284.host, call_564284.base,
                         call_564284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564284, url, valid)

proc call*(call_564285: Call_AssessedMachinesListByAssessment_564274;
          assessmentName: string; subscriptionId: string; resourceGroupName: string;
          projectName: string; groupName: string; apiVersion: string = "2018-02-02"): Recallable =
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
  var path_564286 = newJObject()
  var query_564287 = newJObject()
  add(path_564286, "assessmentName", newJString(assessmentName))
  add(query_564287, "api-version", newJString(apiVersion))
  add(path_564286, "subscriptionId", newJString(subscriptionId))
  add(path_564286, "resourceGroupName", newJString(resourceGroupName))
  add(path_564286, "projectName", newJString(projectName))
  add(path_564286, "groupName", newJString(groupName))
  result = call_564285.call(path_564286, query_564287, nil, nil, nil)

var assessedMachinesListByAssessment* = Call_AssessedMachinesListByAssessment_564274(
    name: "assessedMachinesListByAssessment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}/assessedMachines",
    validator: validate_AssessedMachinesListByAssessment_564275, base: "",
    url: url_AssessedMachinesListByAssessment_564276, schemes: {Scheme.Https})
type
  Call_AssessedMachinesGet_564288 = ref object of OpenApiRestCall_563557
proc url_AssessedMachinesGet_564290(protocol: Scheme; host: string; base: string;
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

proc validate_AssessedMachinesGet_564289(path: JsonNode; query: JsonNode;
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
  var valid_564291 = path.getOrDefault("assessmentName")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "assessmentName", valid_564291
  var valid_564292 = path.getOrDefault("subscriptionId")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "subscriptionId", valid_564292
  var valid_564293 = path.getOrDefault("resourceGroupName")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "resourceGroupName", valid_564293
  var valid_564294 = path.getOrDefault("projectName")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "projectName", valid_564294
  var valid_564295 = path.getOrDefault("assessedMachineName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "assessedMachineName", valid_564295
  var valid_564296 = path.getOrDefault("groupName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "groupName", valid_564296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564297 = query.getOrDefault("api-version")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = newJString("2018-02-02"))
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

proc call*(call_564299: Call_AssessedMachinesGet_564288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an assessed machine with its size & cost estimate that was evaluated in the specified assessment.
  ## 
  let valid = call_564299.validator(path, query, header, formData, body)
  let scheme = call_564299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564299.url(scheme.get, call_564299.host, call_564299.base,
                         call_564299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564299, url, valid)

proc call*(call_564300: Call_AssessedMachinesGet_564288; assessmentName: string;
          subscriptionId: string; resourceGroupName: string; projectName: string;
          assessedMachineName: string; groupName: string;
          apiVersion: string = "2018-02-02"): Recallable =
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
  var path_564301 = newJObject()
  var query_564302 = newJObject()
  add(path_564301, "assessmentName", newJString(assessmentName))
  add(query_564302, "api-version", newJString(apiVersion))
  add(path_564301, "subscriptionId", newJString(subscriptionId))
  add(path_564301, "resourceGroupName", newJString(resourceGroupName))
  add(path_564301, "projectName", newJString(projectName))
  add(path_564301, "assessedMachineName", newJString(assessedMachineName))
  add(path_564301, "groupName", newJString(groupName))
  result = call_564300.call(path_564301, query_564302, nil, nil, nil)

var assessedMachinesGet* = Call_AssessedMachinesGet_564288(
    name: "assessedMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}/assessedMachines/{assessedMachineName}",
    validator: validate_AssessedMachinesGet_564289, base: "",
    url: url_AssessedMachinesGet_564290, schemes: {Scheme.Https})
type
  Call_AssessmentsGetReportDownloadUrl_564303 = ref object of OpenApiRestCall_563557
proc url_AssessmentsGetReportDownloadUrl_564305(protocol: Scheme; host: string;
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

proc validate_AssessmentsGetReportDownloadUrl_564304(path: JsonNode;
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
  var valid_564306 = path.getOrDefault("assessmentName")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "assessmentName", valid_564306
  var valid_564307 = path.getOrDefault("subscriptionId")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "subscriptionId", valid_564307
  var valid_564308 = path.getOrDefault("resourceGroupName")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "resourceGroupName", valid_564308
  var valid_564309 = path.getOrDefault("projectName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "projectName", valid_564309
  var valid_564310 = path.getOrDefault("groupName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "groupName", valid_564310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564311 = query.getOrDefault("api-version")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564311 != nil:
    section.add "api-version", valid_564311
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564312 = header.getOrDefault("Accept-Language")
  valid_564312 = validateParameter(valid_564312, JString, required = false,
                                 default = nil)
  if valid_564312 != nil:
    section.add "Accept-Language", valid_564312
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564313: Call_AssessmentsGetReportDownloadUrl_564303;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the URL for downloading the assessment in a report format.
  ## 
  let valid = call_564313.validator(path, query, header, formData, body)
  let scheme = call_564313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564313.url(scheme.get, call_564313.host, call_564313.base,
                         call_564313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564313, url, valid)

proc call*(call_564314: Call_AssessmentsGetReportDownloadUrl_564303;
          assessmentName: string; subscriptionId: string; resourceGroupName: string;
          projectName: string; groupName: string; apiVersion: string = "2018-02-02"): Recallable =
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
  var path_564315 = newJObject()
  var query_564316 = newJObject()
  add(path_564315, "assessmentName", newJString(assessmentName))
  add(query_564316, "api-version", newJString(apiVersion))
  add(path_564315, "subscriptionId", newJString(subscriptionId))
  add(path_564315, "resourceGroupName", newJString(resourceGroupName))
  add(path_564315, "projectName", newJString(projectName))
  add(path_564315, "groupName", newJString(groupName))
  result = call_564314.call(path_564315, query_564316, nil, nil, nil)

var assessmentsGetReportDownloadUrl* = Call_AssessmentsGetReportDownloadUrl_564303(
    name: "assessmentsGetReportDownloadUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}/downloadUrl",
    validator: validate_AssessmentsGetReportDownloadUrl_564304, base: "",
    url: url_AssessmentsGetReportDownloadUrl_564305, schemes: {Scheme.Https})
type
  Call_MachinesListByProject_564317 = ref object of OpenApiRestCall_563557
proc url_MachinesListByProject_564319(protocol: Scheme; host: string; base: string;
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

proc validate_MachinesListByProject_564318(path: JsonNode; query: JsonNode;
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
  var valid_564320 = path.getOrDefault("subscriptionId")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "subscriptionId", valid_564320
  var valid_564321 = path.getOrDefault("resourceGroupName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "resourceGroupName", valid_564321
  var valid_564322 = path.getOrDefault("projectName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "projectName", valid_564322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564323 = query.getOrDefault("api-version")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564323 != nil:
    section.add "api-version", valid_564323
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564324 = header.getOrDefault("Accept-Language")
  valid_564324 = validateParameter(valid_564324, JString, required = false,
                                 default = nil)
  if valid_564324 != nil:
    section.add "Accept-Language", valid_564324
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564325: Call_MachinesListByProject_564317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get data of all the machines available in the project. Returns a json array of objects of type 'machine' defined in Models section.
  ## 
  let valid = call_564325.validator(path, query, header, formData, body)
  let scheme = call_564325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564325.url(scheme.get, call_564325.host, call_564325.base,
                         call_564325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564325, url, valid)

proc call*(call_564326: Call_MachinesListByProject_564317; subscriptionId: string;
          resourceGroupName: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
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
  var path_564327 = newJObject()
  var query_564328 = newJObject()
  add(query_564328, "api-version", newJString(apiVersion))
  add(path_564327, "subscriptionId", newJString(subscriptionId))
  add(path_564327, "resourceGroupName", newJString(resourceGroupName))
  add(path_564327, "projectName", newJString(projectName))
  result = call_564326.call(path_564327, query_564328, nil, nil, nil)

var machinesListByProject* = Call_MachinesListByProject_564317(
    name: "machinesListByProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/machines",
    validator: validate_MachinesListByProject_564318, base: "",
    url: url_MachinesListByProject_564319, schemes: {Scheme.Https})
type
  Call_MachinesGet_564329 = ref object of OpenApiRestCall_563557
proc url_MachinesGet_564331(protocol: Scheme; host: string; base: string;
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

proc validate_MachinesGet_564330(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564332 = path.getOrDefault("machineName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "machineName", valid_564332
  var valid_564333 = path.getOrDefault("subscriptionId")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "subscriptionId", valid_564333
  var valid_564334 = path.getOrDefault("resourceGroupName")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "resourceGroupName", valid_564334
  var valid_564335 = path.getOrDefault("projectName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "projectName", valid_564335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564336 = query.getOrDefault("api-version")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564336 != nil:
    section.add "api-version", valid_564336
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564337 = header.getOrDefault("Accept-Language")
  valid_564337 = validateParameter(valid_564337, JString, required = false,
                                 default = nil)
  if valid_564337 != nil:
    section.add "Accept-Language", valid_564337
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564338: Call_MachinesGet_564329; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the machine with the specified name. Returns a json object of type 'machine' defined in Models section.
  ## 
  let valid = call_564338.validator(path, query, header, formData, body)
  let scheme = call_564338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564338.url(scheme.get, call_564338.host, call_564338.base,
                         call_564338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564338, url, valid)

proc call*(call_564339: Call_MachinesGet_564329; machineName: string;
          subscriptionId: string; resourceGroupName: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
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
  var path_564340 = newJObject()
  var query_564341 = newJObject()
  add(path_564340, "machineName", newJString(machineName))
  add(query_564341, "api-version", newJString(apiVersion))
  add(path_564340, "subscriptionId", newJString(subscriptionId))
  add(path_564340, "resourceGroupName", newJString(resourceGroupName))
  add(path_564340, "projectName", newJString(projectName))
  result = call_564339.call(path_564340, query_564341, nil, nil, nil)

var machinesGet* = Call_MachinesGet_564329(name: "machinesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/machines/{machineName}",
                                        validator: validate_MachinesGet_564330,
                                        base: "", url: url_MachinesGet_564331,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsListByResourceGroup_564342 = ref object of OpenApiRestCall_563557
proc url_ProjectsListByResourceGroup_564344(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsListByResourceGroup_564343(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564345 = path.getOrDefault("subscriptionId")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "subscriptionId", valid_564345
  var valid_564346 = path.getOrDefault("resourceGroupName")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "resourceGroupName", valid_564346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564347 = query.getOrDefault("api-version")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = newJString("2018-02-02"))
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
  if body != nil:
    result.add "body", body

proc call*(call_564349: Call_ProjectsListByResourceGroup_564342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the projects in the resource group.
  ## 
  let valid = call_564349.validator(path, query, header, formData, body)
  let scheme = call_564349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564349.url(scheme.get, call_564349.host, call_564349.base,
                         call_564349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564349, url, valid)

proc call*(call_564350: Call_ProjectsListByResourceGroup_564342;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## projectsListByResourceGroup
  ## Get all the projects in the resource group.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  var path_564351 = newJObject()
  var query_564352 = newJObject()
  add(query_564352, "api-version", newJString(apiVersion))
  add(path_564351, "subscriptionId", newJString(subscriptionId))
  add(path_564351, "resourceGroupName", newJString(resourceGroupName))
  result = call_564350.call(path_564351, query_564352, nil, nil, nil)

var projectsListByResourceGroup* = Call_ProjectsListByResourceGroup_564342(
    name: "projectsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects",
    validator: validate_ProjectsListByResourceGroup_564343, base: "",
    url: url_ProjectsListByResourceGroup_564344, schemes: {Scheme.Https})
type
  Call_ProjectsCreate_564365 = ref object of OpenApiRestCall_563557
proc url_ProjectsCreate_564367(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsCreate_564366(path: JsonNode; query: JsonNode;
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
  var valid_564368 = path.getOrDefault("subscriptionId")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "subscriptionId", valid_564368
  var valid_564369 = path.getOrDefault("resourceGroupName")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "resourceGroupName", valid_564369
  var valid_564370 = path.getOrDefault("projectName")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "projectName", valid_564370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564371 = query.getOrDefault("api-version")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564371 != nil:
    section.add "api-version", valid_564371
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564372 = header.getOrDefault("Accept-Language")
  valid_564372 = validateParameter(valid_564372, JString, required = false,
                                 default = nil)
  if valid_564372 != nil:
    section.add "Accept-Language", valid_564372
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   project: JObject
  ##          : New or Updated project object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564374: Call_ProjectsCreate_564365; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a project with specified name. If a project already exists, update it.
  ## 
  let valid = call_564374.validator(path, query, header, formData, body)
  let scheme = call_564374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564374.url(scheme.get, call_564374.host, call_564374.base,
                         call_564374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564374, url, valid)

proc call*(call_564375: Call_ProjectsCreate_564365; subscriptionId: string;
          resourceGroupName: string; projectName: string;
          apiVersion: string = "2018-02-02"; project: JsonNode = nil): Recallable =
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
  var path_564376 = newJObject()
  var query_564377 = newJObject()
  var body_564378 = newJObject()
  add(query_564377, "api-version", newJString(apiVersion))
  add(path_564376, "subscriptionId", newJString(subscriptionId))
  if project != nil:
    body_564378 = project
  add(path_564376, "resourceGroupName", newJString(resourceGroupName))
  add(path_564376, "projectName", newJString(projectName))
  result = call_564375.call(path_564376, query_564377, nil, nil, body_564378)

var projectsCreate* = Call_ProjectsCreate_564365(name: "projectsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
    validator: validate_ProjectsCreate_564366, base: "", url: url_ProjectsCreate_564367,
    schemes: {Scheme.Https})
type
  Call_ProjectsGet_564353 = ref object of OpenApiRestCall_563557
proc url_ProjectsGet_564355(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsGet_564354(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564356 = path.getOrDefault("subscriptionId")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "subscriptionId", valid_564356
  var valid_564357 = path.getOrDefault("resourceGroupName")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "resourceGroupName", valid_564357
  var valid_564358 = path.getOrDefault("projectName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "projectName", valid_564358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564359 = query.getOrDefault("api-version")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564359 != nil:
    section.add "api-version", valid_564359
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564360 = header.getOrDefault("Accept-Language")
  valid_564360 = validateParameter(valid_564360, JString, required = false,
                                 default = nil)
  if valid_564360 != nil:
    section.add "Accept-Language", valid_564360
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564361: Call_ProjectsGet_564353; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the project with the specified name.
  ## 
  let valid = call_564361.validator(path, query, header, formData, body)
  let scheme = call_564361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564361.url(scheme.get, call_564361.host, call_564361.base,
                         call_564361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564361, url, valid)

proc call*(call_564362: Call_ProjectsGet_564353; subscriptionId: string;
          resourceGroupName: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
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
  var path_564363 = newJObject()
  var query_564364 = newJObject()
  add(query_564364, "api-version", newJString(apiVersion))
  add(path_564363, "subscriptionId", newJString(subscriptionId))
  add(path_564363, "resourceGroupName", newJString(resourceGroupName))
  add(path_564363, "projectName", newJString(projectName))
  result = call_564362.call(path_564363, query_564364, nil, nil, nil)

var projectsGet* = Call_ProjectsGet_564353(name: "projectsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
                                        validator: validate_ProjectsGet_564354,
                                        base: "", url: url_ProjectsGet_564355,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsUpdate_564391 = ref object of OpenApiRestCall_563557
proc url_ProjectsUpdate_564393(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsUpdate_564392(path: JsonNode; query: JsonNode;
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
  var valid_564394 = path.getOrDefault("subscriptionId")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "subscriptionId", valid_564394
  var valid_564395 = path.getOrDefault("resourceGroupName")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "resourceGroupName", valid_564395
  var valid_564396 = path.getOrDefault("projectName")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "projectName", valid_564396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564397 = query.getOrDefault("api-version")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564397 != nil:
    section.add "api-version", valid_564397
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564398 = header.getOrDefault("Accept-Language")
  valid_564398 = validateParameter(valid_564398, JString, required = false,
                                 default = nil)
  if valid_564398 != nil:
    section.add "Accept-Language", valid_564398
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   project: JObject
  ##          : Updated project object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564400: Call_ProjectsUpdate_564391; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a project with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  let valid = call_564400.validator(path, query, header, formData, body)
  let scheme = call_564400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564400.url(scheme.get, call_564400.host, call_564400.base,
                         call_564400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564400, url, valid)

proc call*(call_564401: Call_ProjectsUpdate_564391; subscriptionId: string;
          resourceGroupName: string; projectName: string;
          apiVersion: string = "2018-02-02"; project: JsonNode = nil): Recallable =
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
  var path_564402 = newJObject()
  var query_564403 = newJObject()
  var body_564404 = newJObject()
  add(query_564403, "api-version", newJString(apiVersion))
  add(path_564402, "subscriptionId", newJString(subscriptionId))
  if project != nil:
    body_564404 = project
  add(path_564402, "resourceGroupName", newJString(resourceGroupName))
  add(path_564402, "projectName", newJString(projectName))
  result = call_564401.call(path_564402, query_564403, nil, nil, body_564404)

var projectsUpdate* = Call_ProjectsUpdate_564391(name: "projectsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
    validator: validate_ProjectsUpdate_564392, base: "", url: url_ProjectsUpdate_564393,
    schemes: {Scheme.Https})
type
  Call_ProjectsDelete_564379 = ref object of OpenApiRestCall_563557
proc url_ProjectsDelete_564381(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsDelete_564380(path: JsonNode; query: JsonNode;
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
  var valid_564382 = path.getOrDefault("subscriptionId")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "subscriptionId", valid_564382
  var valid_564383 = path.getOrDefault("resourceGroupName")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "resourceGroupName", valid_564383
  var valid_564384 = path.getOrDefault("projectName")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "projectName", valid_564384
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564385 = query.getOrDefault("api-version")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564385 != nil:
    section.add "api-version", valid_564385
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564386 = header.getOrDefault("Accept-Language")
  valid_564386 = validateParameter(valid_564386, JString, required = false,
                                 default = nil)
  if valid_564386 != nil:
    section.add "Accept-Language", valid_564386
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564387: Call_ProjectsDelete_564379; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the project. Deleting non-existent project is a no-operation.
  ## 
  let valid = call_564387.validator(path, query, header, formData, body)
  let scheme = call_564387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564387.url(scheme.get, call_564387.host, call_564387.base,
                         call_564387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564387, url, valid)

proc call*(call_564388: Call_ProjectsDelete_564379; subscriptionId: string;
          resourceGroupName: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
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
  var path_564389 = newJObject()
  var query_564390 = newJObject()
  add(query_564390, "api-version", newJString(apiVersion))
  add(path_564389, "subscriptionId", newJString(subscriptionId))
  add(path_564389, "resourceGroupName", newJString(resourceGroupName))
  add(path_564389, "projectName", newJString(projectName))
  result = call_564388.call(path_564389, query_564390, nil, nil, nil)

var projectsDelete* = Call_ProjectsDelete_564379(name: "projectsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
    validator: validate_ProjectsDelete_564380, base: "", url: url_ProjectsDelete_564381,
    schemes: {Scheme.Https})
type
  Call_ProjectsGetKeys_564405 = ref object of OpenApiRestCall_563557
proc url_ProjectsGetKeys_564407(protocol: Scheme; host: string; base: string;
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

proc validate_ProjectsGetKeys_564406(path: JsonNode; query: JsonNode;
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
  var valid_564408 = path.getOrDefault("subscriptionId")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "subscriptionId", valid_564408
  var valid_564409 = path.getOrDefault("resourceGroupName")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "resourceGroupName", valid_564409
  var valid_564410 = path.getOrDefault("projectName")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "projectName", valid_564410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564411 = query.getOrDefault("api-version")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_564411 != nil:
    section.add "api-version", valid_564411
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_564412 = header.getOrDefault("Accept-Language")
  valid_564412 = validateParameter(valid_564412, JString, required = false,
                                 default = nil)
  if valid_564412 != nil:
    section.add "Accept-Language", valid_564412
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564413: Call_ProjectsGetKeys_564405; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Log Analytics Workspace ID and Primary Key for the specified project.
  ## 
  let valid = call_564413.validator(path, query, header, formData, body)
  let scheme = call_564413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564413.url(scheme.get, call_564413.host, call_564413.base,
                         call_564413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564413, url, valid)

proc call*(call_564414: Call_ProjectsGetKeys_564405; subscriptionId: string;
          resourceGroupName: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
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
  var path_564415 = newJObject()
  var query_564416 = newJObject()
  add(query_564416, "api-version", newJString(apiVersion))
  add(path_564415, "subscriptionId", newJString(subscriptionId))
  add(path_564415, "resourceGroupName", newJString(resourceGroupName))
  add(path_564415, "projectName", newJString(projectName))
  result = call_564414.call(path_564415, query_564416, nil, nil, nil)

var projectsGetKeys* = Call_ProjectsGetKeys_564405(name: "projectsGetKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/keys",
    validator: validate_ProjectsGetKeys_564406, base: "", url: url_ProjectsGetKeys_564407,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
