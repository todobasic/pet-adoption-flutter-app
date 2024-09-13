import 'package:pet_adoption/data/models/pet_post_model.dart';

class SimilarityService {
  double computeSimilarity(PetPostModel postA, PetPostModel postB) {

    // Similarity based on pet's breed (1 if same breed, 0 otherwise)
    double breedScore = postA.breed.toLowerCase() == postB.breed.toLowerCase() ? 1.0 : 0.0;
    
    // Similarity based on pet's type (1 if same type, 0 otherwise)
    double typeScore = postA.type.toLowerCase() == postB.type.toLowerCase() ? 1.0 : 0.0;

    // Similarity based on pet's age (closer ages result in higher score)
    double ageScore = 1 - (postA.age - postB.age).abs() / 10.0;  

    // Similarity based on pet's weight (closer weights result in higher score)
    double weightScore = 1 - (postA.weight - postB.weight).abs() / 10.0;  

    // Combine the scores alltogether to get the similarity score between these two pets
    double similarity = (0.4 * breedScore) + (0.4 * typeScore) + (0.1 * ageScore) + (0.1 * weightScore);

    return similarity;
  }
}